require 'bunny'
require 'thread'

class FibonacciClient
  attr_reader :call_id, :response, :look, :condition,
              :connection, :channel, :sever_queue_name,
              :reply_queue, :exchange

  def initialize(server_queue_name)
    @connection = Bunny.new
    @connection.start

    @channel = @connection.create_channel
    @exchange = @channel.default_exchange
    @sever_queue_name = server_queue_name

    setup_reply_queue
  end

  def call(n)
    @call_id = generate_uuid

    exchange.publish(n.to_s,
                     routing_key: server_queue_name,
                     correlation_id: call_id,
                     reply_to: reply_queue.name)

    lock.synchronize { condition.wait(lock) }

    response
  end

  def stop
    channel.close
    connection.close
  end

  def setup_reply_queue
    @lock = Monitor.new
    @condition = ConditionVariable.new
    that = self
    @reply_queue = channel.queue('', exclusive: true)

    reply_queue.subscribe do |delivery_info, properties, payload|
      if properties[:correlation_id] == that.call_id
        that.response = payload.to_i

        that.look.synchronize { that.condition.signal }
      end
    end
  end

  def generate_uuid
    "#{rand}#{rand}#{rand}"
  end
end

client = FibonacciClient.new("rpc_queue")

n = (ARGV[0] || 30).to_i

p "[x] Requesting fib(#{n})"
response = client.call(n)

p " [.] Got #{response}"
client.stop
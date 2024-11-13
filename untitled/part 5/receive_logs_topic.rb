require 'bunny'
abort "Usage: #{$PROGRAM_NAME} [binding key]" if ARGV.empty?

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.topic('topic_logs')
queue = channel.queue('', exclusive: true)

ARGV.each do |severity|
  queue.bind(exchange, routing_key: severity)
end

p ' [*] Waiting for logs. To exit press CTRL+C'

begin
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts body
  end
rescue Interrupt => _
  channel.close
  connection.close

  exit(0)
end

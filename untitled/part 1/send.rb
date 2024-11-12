#!/usr/bin/env ruby
require 'bunny'
conn = Bunny.new(session_error_handler: false)
conn.start

channel = conn.create_channel
queue = channel.queue('hello')

channel.default_exchange.publish('Hello World!', routing_key: queue.name)
puts " [x] Sent 'Hello World!'"

conn.close


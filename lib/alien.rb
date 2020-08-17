require 'alien/version'
require 'alien/connection'
require 'bunny'
require 'json'

module Alien
  class Error < StandardError; end
  class ConnectionNotOpen < StandardError; end
  class MessageReturnedError < StandardError; end

  class Service
    class << self
      def start(service_name:, **options)
        @connection = Connection
          .new(service_name: service_name, **options)

        @connection.start

        @connection.queue.subscribe do |delivery_info, metadata, payload|
          #puts delivery_info.inspect
          puts metadata.inspect
          puts JSON.parse(payload)
        end

        @connection.exchange.on_return do |info, properties, content|
          puts "#{content} was returned! reply_code = #{info.reply_code}, reply_text = #{info.reply_text}"
          raise MessageReturnedError.new("This message was returned: #{content}")
        end

        self
      end

      def stop
        @connection.stop
      end

      def publish(service_name, payload, &block)
        @connection.exchange.publish(payload, routing_key: service_name, content_type: 'application/json')
      end
    end
  end

  module ConnectionUtilities
    def start(conn)
      conn.start
    end

    def stop(conn)
      conn.stop
    end
  end
end

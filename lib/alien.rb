require 'alien/version'
require 'alien/connection'
require 'alien/payload'
require 'bunny'
require 'json'
require 'securerandom'

module Alien
  class Error < StandardError; end
  class ConnectionNotOpen < StandardError; end
  class MessageReturnedError < StandardError; end

  class Service

    class << self
      def start(service_name:, **options)
        default_options = {
          host: 'localhost',
          port: '5672',
          user: 'guest',
          pass: 'guest',
          threaded: true
        }.merge(options)
        new(service_name, **default_options)
      end

      def stop(service)
        service.connection.stop
      end
    end

    attr_reader :service_name

    def initialize(service_name, **options)
      @service_name = service_name
      @connection ||= Connection
        .new(service_name: service_name, **options)
      @connection.start

      @connection.queue.subscribe do |delivery_info, metadata, payload|
        #puts delivery_info.inspect
        #puts metadata.inspect
        puts JSON.parse(payload)
      end

      @connection.exchange.on_return do |info, properties, content|
        puts "#{content} was returned! reply_code = #{info.reply_code}, reply_text = #{info.reply_text}"
        raise MessageReturnedError.new("#{content} was returned! reply_code = #{info.reply_code}, reply_text = #{info.reply_text}")
      end
    end

    def identifier
      "#{service_name}-#{SecureRandom.uuid}"
    end

    def publish(service_name, payload, &block)
      @connection.exchange.publish(
        Alien::Payload.new(payload: payload).format,
        routing_key: service_name,
        content_type: 'application/json'
      )
    end

    private

    def format_payload

    end
  end
end

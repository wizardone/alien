require 'alien/version'
require 'bunny'

module Alien
  class Error < StandardError; end

  class << self
    def start(service_name:, **options)
      @connection = Connection.new(service_name: service_name, **options)
      
      @connection.queue.subscribe do |delivery_info, metadata, payload|
        puts delivery_info.inspect
        puts metadata.inspect
        puts "Received #{payload}"
      end
    end

    def stop
      @connection.server.stop
    end

    def publish(service_name, payload, &block)
      @connection.exchange.publish(payload, routing_key: service_name)
    end
  end

  class Connection

    attr_reader :server, :service_name

    def initialize(service_name:, **options)
      @service_name = service_name
      @server = Bunny.new
      #@channel = @server.create_channel
      #@queue = @channel.queue(name, auto_delete: true)
      #@exchange = @channel.default_exchange
    end

    def start
      server.start
    end

    def stop
      server.stop
    end

    def channel
      @channel ||= @server.create_channel
    end

    def queue
      @queue ||= channel.queue(service_name, auto_delete: true)
    end

    def exchange
      @exchange ||= channel.default_exchange
    end
  end
end

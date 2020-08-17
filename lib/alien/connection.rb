module Alien
  class Connection
    attr_reader :conn, :service_name

    def initialize(service_name:, **options)
      default_options = {

      }.merge(options)
      @conn = Bunny.new
      @service_name = service_name
    end

    def start
      conn.start
    end

    def stop
      conn.close
    end

    def channel(**options)
      @channel ||= conn.create_channel()
    end

    def queue
      @queue ||= channel.queue(service_name, durable: true, auto_delete: false)
    end

    def exchange
      @exchange ||= channel.default_exchange
    end
  end
end

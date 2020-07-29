require 'alien/version'
require 'bunny'

module Alien
  class Error < StandardError; end

  class << self
    def start(name:, **options)
      Connection.new(name: name, **options)
    end

    def stop
    end
  end

  class Connection

    attr_reader :ampq, :exchange, :name

    def initialize(name:, **options)
      @name = name
      @ampq = Bunny.new
      @ampq.start

     # ch = @ampq.create_channel
     # q = ch.queue(name, auto_delete: true)
     # @exchange = ch.default_exchange

     # q.subscribe do |delivery_info, metadata, payload|
     #   puts "Received #{payload}"
     # end
    end
  end

end

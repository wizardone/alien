require "alien/version"

module Alien
  class Error < StandardError; end

  class << self
    def start
    end

    def stop
    end
  end

  def initialize(name:, **options)
    # RabbitMQ connection
  end

end

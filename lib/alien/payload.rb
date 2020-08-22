module Alien
  Payload = Struct.new(:payload, keyword_init: true) do
    def format
      {
        'body' =>     payload[:body]     || "",
        'verb' =>     payload[:verb]     || "GET",
        'headers' =>  payload[:headers]  || {},
        'path' =>     payload[:path]     || "/",
        'query' =>    payload[:query]    || {},
        'scheme' =>   payload[:protocol] || 'http',
        'host' =>     payload[:hostname] || '127.0.0.1',
        'port' =>     payload[:port]     || 8080,
        'session' =>  payload[:session]
      }.to_json
    end
  end
end

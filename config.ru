require 'rack'
require 'json'

# Load environment variables from .env file
require 'dotenv'
Dotenv.load

# Map routes to handlers
app = Rack::URLMap.new(
  "/api/fetch-reviews" => lambda { |env|
    req = Rack::Request.new(env)
    res = Rack::Response.new
    res['Content-Type'] = 'application/json'

    begin
      require_relative './api/fetch-reviews'
      Handler.call(req, res)
      [res.status, res.headers, [res.body]]
    rescue => e
      [500, {'Content-Type' => 'application/json'}, [{error: e.message, backtrace: e.backtrace}.to_json]]
    end
  },
  
  "/api/health" => lambda { |env|
    req = Rack::Request.new(env)
    res = Rack::Response.new
    res['Content-Type'] = 'application/json'

    begin
      require_relative './api/health'
      Handler.call(req, res)
      [res.status, res.headers, [res.body]]
    rescue => e
      [500, {'Content-Type' => 'application/json'}, [{error: e.message, backtrace: e.backtrace}.to_json]]
    end
  }
)

run app

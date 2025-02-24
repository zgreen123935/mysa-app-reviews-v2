require 'json'

class RackHandler
  def self.call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new
    res['Content-Type'] = 'application/json'

    Handler.call(req, res)

    [res.status, res.headers, [res.body]]
  end
end

run RackHandler

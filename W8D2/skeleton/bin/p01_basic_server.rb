require 'rack'

class MyController 

    def initialize(res, req)
        @res, @req = res, req
    end

    def execute
        if (@req.path == "/i/love/app/academy")
            @res.write("i/love/app/academy")
        else
            @res.write('hello')
        end
    end
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  MyController.new(res,req).execute
  res.finish
end


Rack::Server.start({
    app: app,
    Port: 3000 
})
require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req
    cookie = @req.cookies['_rails_lite_app']
    @sesh = (cookie ? JSON.parse(cookie) : {})
  end

  def [](key)
    @sesh[key]

  end

  def []=(key, val)
    @sesh[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie('_rails_lite_app',
    {path: '/',
    value: @sesh.to_json})
  end


end

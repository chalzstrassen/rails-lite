require 'json'
require 'byebug'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @req = req
      the_cookie = @req.cookies.select {|cookie| cookie.name == '_rails_lite_app' }
      if the_cookie.empty?
        @cookie_hash = {}
      else
        @cookie_hash = JSON.parse(the_cookie.first.value)
      end
    end

    def [](key)
      @cookie_hash[key]
    end

    def []=(key, val)
      @cookie_hash[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)

      new_cookie = WEBrick::Cookie.new('_rails_lite_app', @cookie_hash.to_json)
      res.cookies << new_cookie
    end
  end
end

require_relative '../phase6/controller_base'
module Phase7
  class Flash < Phase6::ControllerBase
    def initialize(req)
      @req = req
      flash = @req.cookies.select {|cookie| cookie.name == 'flash' }
      if flash.empty?
        @flash_hash = {}
      else
        @flash_hash = JSON.parse(the_cookie.first.value)
      end
    end

    def now
      res.cookies << flash
    end
  end
end

require_relative '../phase6/controller_base'
module Phase7
  class Flash < Phase6::ControllerBase
    def initialize(key, val)
      @flash = WEBrick::Cookie.new(key, val)
    end

    def [](key)

    end

    def []=(key,value)

    end

    def now

    end
  end
end

require_relative '../phase6/controller_base'
module Phase7
  class Flash < Phase6::ControllerBase
    attr_accessor :flash
    def initialize(key, val)
      @flash[key] = val
    end

    def called?

    end

    def [](key)
      flash[key]
    end

    def now

    end
  end
end

require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
        @params = route_params
        unless req.query_string.nil?
          req_query = req.query_string
          parse_www_encoded_form(req_query)
        end

        unless req.body.nil?
          parse_www_encoded_form(req.body)
        end
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      in_arr = URI::decode_www_form(www_encoded_form)
      in_arr.each do |pair|
        parsed_key = parse_key(pair.first)
        value = pair.last

        str_json = ""
        num_times = 0

        parsed_key.each do |key|
          str_json+= "{'#{key}'=>"
          str_json+= "'#{value}'" if key==parsed_key.last
          num_times += 1
        end
        str_json += "}"*num_times
        parsed_hash = JSON.parse(str_json.gsub("'",'"').gsub('=>',':'))
        parsed_hash.each do |key, val|
          @params[key] = val
        end
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end

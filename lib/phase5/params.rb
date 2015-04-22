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
        full_arr = parsed_key + [value]
        nested_hash = nest_hash(full_arr)
        @params[nested_hash.keys.first] = nested_hash.values.first
      end
    end

    def nest_hash(arr)
      return arr.first if arr.length == 1

      { arr.shift => nest_hash(arr)}
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end

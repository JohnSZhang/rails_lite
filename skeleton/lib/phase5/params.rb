require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = {}
      query = req.query_string
      if query
        req_params = URI::decode_www_form(query)
        @params = @params.merge(parse_www_encoded_form(req_params))
      end
      body = req.body
      if body
        uri_decoded = URI::decode_www_form(body)
        decoded_body = parse_www_encoded_form(uri_decoded)
        @params = @params.merge(decoded_body)
      end
    end

    def [](key)
      key = key.to_s if key.is_a?(Symbol)
      @params[key]
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

      result = {}
      www_encoded_form.each do |section|
        keys = parse_key(section.first)
        value = section.last
        new_key = keys.shift

        if keys.count == 0
          result[new_key] = value
        elsif result[new_key].is_a?(Hash)
          inner_hash = result[new_key]
        else
          result[new_key] = {}
          inner_hash = result[new_key]
        end

        until keys.count < 2
          new_key = keys.shift
          if inner_hash[new_key].is_a?(Hash)
            inner_hash = inner_hash[new_key]
          else
            inner_hash[new_key] = {}
            inner_hash = inner_hash[new_key]
          end
        end
        inner_hash && inner_hash[keys.shift] = value
      end
      result
    end
    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end

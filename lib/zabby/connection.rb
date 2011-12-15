module Zabby
  class Connection

    API_OUTPUT_SHORTEN = "shorten"
    API_OUTPUT_REFER = "refer"
    API_OUTPUT_EXTEND = "extend"


    attr_reader :uri, :request_path, :api_user, :api_password
    attr_reader :auth
    attr_reader :request_id


    def initialize(api_url)
      @uri = URI.parse(api_url)
      @request_path = uri.path.empty? ? "/api_jsonrpc.php" : uri.path
      @request_id = 0
      @auth = nil
    end
    
    def login( api_user, api_password)
      @api_user = api_user
      @api_password = api_password
      authenticate
    end

    def logout
      @auth = nil
    end

    def logged_in?
      !@auth.nil?
    end
    
    def next_request_id
      @request_id += 1
    end

    def authenticate
      @auth ||= begin
        auth_message = {
            'auth' => nil,
            'method' => 'user.authenticate',
            'params' => {
                'user' => @api_user,
                'password' => @api_password,
                '0' => '0'
            }
        }
        do_request(auth_message)
      end
    end


    def perform_request(controller, action, params)
      raise AuthenticationError.new("Not logged in") if !logged_in?

      message = message_for(controller, action, params)
      do_request(message)
    end

    def message_for(controller, action, params = {})
      {
          'method' => "#{controller}.#{action}",
          'params' => { :output=>API_OUTPUT_EXTEND }.merge(params),
          'auth' => @auth
      }
    end

    def do_request(message)
      message.merge!({ 'id' => next_request_id, 'jsonrpc' => '2.0' })

      request = Net::HTTP::Post.new(@request_path)
      request.add_field('Content-Type', 'application/json-rpc')
      request.body = JSON.generate(message)
      http =  Net::HTTP.new(@uri.host, @uri.port)
      if @uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response = http.request(request)

      if (response.code != "200") then
        raise ResponseCodeError.new("Response code from [#{@api_url}] is #{response.code})")
      end

      response_body_hash = JSON.parse(response.body)

      #if not ( responce_body_hash['id'] == id ) then
      # raise Zabbix::InvalidAnswerId.new("Wrong ID in zabbix answer")
      #end

      # Check errors in zabbix answer. If error exist - raise exception Zabbix::Error
      if (error = response_body_hash['error']) then
        error_message = error['message']
        error_data = error['data']
        error_code = error['code']

        e_message = "Code: [" + error_code.to_s + "]. Message: [" + error_message +
                "]. Data: [" + error_data + "]."

        if error_data == "Login name or password is incorrect"
          raise AuthenticationError.new(e_message)
        else
          raise StandardError.new(e_message)
        end
      end

      response_body_hash['result']
    end
  end
end

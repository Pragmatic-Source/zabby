# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011-2012 Farzad FARID
# License:: Simplified BSD License

module Zabby
  class Connection
    # Name of the Zabbix RPC script
    JSONRPC_SCRIPT = "/api_jsonrpc.php"

    attr_reader :uri, :request_path, :user, :password, :proxy_host, :proxy_user, :proxy_password
    attr_reader :auth
    attr_reader :request_id

    def initialize
      reset
    end

    def reset
      @uri = @user = @password = @proxy_host = @proxy_user = @proxy_password = nil
      @request_id = 0
      @auth = nil
    end

    def login(config)
      return @auth if @auth
      
      @uri = URI.parse(config.server)
      @user = config.user
      @password = config.password
      if config.proxy_host
        @proxy_host = URI.parse(config.proxy_host)
        @proxy_user = config.proxy_user
        @proxy_password = config.proxy_password
      end
      @request_path = @uri.path[-4,4] == '.php' ? @uri.path : @uri.path + JSONRPC_SCRIPT
      authenticate
    end

    def logout
      reset
    end

    def logged_in?
      !@auth.nil?
    end
    
    def next_request_id
      @request_id += 1
    end

    # @return [Authentication key]
    def authenticate
      auth_message = format_message('user', 'login',
                                    'user' => @user,
                                    'password' => @password)
      @auth = query_zabbix_rpc(auth_message)
    rescue Exception => e
      @auth = nil
      raise e
    end

    def format_message(element, action, params = {})
      {
          'jsonrpc' => '2.0',
          'id' => next_request_id,
          'method' => "#{element}.#{action}",
          'params' => params,
          'auth' => @auth
      }
    end

    # Perform an authenticated request
    # @return [Object] The Zabbix response (Hash, Boolean, etc.) in JSON format.
    def perform_request(element, action, params)
      raise AuthenticationError.new("Not logged in") if !logged_in?

      message = format_message(element, action, params)
      query_zabbix_rpc(message)
    end

    # Prepare a JSON request HTTP Post format
    # @param [Hash] message A hash with all parameters for the Zabbix web service.
    # @return [Net::HTTP::Post] Message ready to be POSTed.
    def request(message)
      req = Net::HTTP::Post.new(@request_path)
      req.add_field('Content-Type', 'application/json-rpc')
      req.body = JSON.generate(message)
      req
    end

    # Prepare http object
    def http
      if @proxy_host
        http = Net::HTTP::Proxy(@proxy_host.host, @proxy_host.port, @proxy_user, @proxy_password).new(@uri.host, @uri.port)
      else
        http = Net::HTTP.new(@uri.host, @uri.port)
      end
      if @uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http
    end

    # Raise a Zabby exception
    # @param [Hash] zabbix_response JSON formatted Zabbix response.
    # @raises [Zabby::AuthenticationError] Authentication error.
    # @raises [zabby::APIError] Generic Zabbix Web Services error.
    def format_exception(zabbix_response)
      error = zabbix_response['error']
      error_message = error['message']
      error_data = error['data']
      error_code = error['code']

      if error_data == "Login name or password is incorrect"
        raise AuthenticationError.new(error_message, error_code, error_data)
      else
        raise APIError.new(error_message, error_code, error_data)
      end
    end

    # Query the Zabbix Web Services and extract the JSON response.
    # @param [Hash] message request in JSON format.
    # @return [Object] The Zabbix response (Hash, Boolean, etc.) in JSON format.
    # @raises [Zabby::ResponseCodeError] HTTP error.
    def query_zabbix_rpc(message)
      # Send the request!
      http_response = http.request(request(message))

      # Check for HTTP errors.
      if http_response.code != "200"
        raise ResponseCodeError.new("Error from #{@uri}", http_response.code, http_response.body)
      end

      zabbix_response = JSON.parse(http_response.body)

      # Check for Zabbix errors.
      if zabbix_response['error']
        format_exception(zabbix_response)
      end

      zabbix_response['result']
    end
  end
end

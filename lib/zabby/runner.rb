module Zabby
  class Runner
    attr_reader :config, :connection

    def initialize &block
      @config = Zabby::Config.new &block
      @connection = Zabby::Connection.new
    end

    def setup &block
      @config.setup &block
    end

    def set(key_value = nil)
      if key_value.nil?
        @config.list
      elsif [ String, Symbol ].include?(key_value.class)
        puts "#{key_value} = #{@config.send(key_value)}"
      elsif key_value.instance_of? Hash
        key = key_value.keys.first
        value = key_value[key]
        @config.send(key, value)
      end
    end
    
    def login
      @connection.login(@config)
    end

    def logout
      @connection.logout
    end

    def logged_in?
      @connection.logged_in?
    end

    def run &block
      instance_eval(&block) if block_given?
    end
  end
end
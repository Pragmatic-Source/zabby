# Configuration setting
module Zabby
  class Config
    SETTING_LIST = %w{host user password proxy_host proxy_user proxy_password}
    
    def initialize &block
      setup(&block)
    end

    def setup &block
      instance_eval(&block) if block_given?
    end

    def list
      SETTING_LIST.each do |k|
        puts "#{k} = #{instance_variable_get("@#{k}")}"
      end
    end

    def method_missing(name, *args, &block)
      name = name.to_s.gsub(/=$/, '')
      raise ConfigurationError.new("Unknown setting '#{name}'") if !SETTING_LIST.include?(name.to_s)

      if args.empty?
        instance_variable_get("@#{name}")
      elsif args.size != 1
        raise ConfigurationError.new("Too many values for '#{name}'")
      else
        instance_variable_set("@#{name}", args.first)
      end
    end
  end
end
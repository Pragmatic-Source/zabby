# Configuration setting
module Zabby
  class Config
    SETTING_LIST = %w{host user password proxy_host proxy_user proxy_password}
    
    def initialize
      @settings = {}
      SETTING_LIST.each do |k|
        @settings[k.to_sym] = nil
      end
      yield self if block_given?
    end

    def list
      @settings
    end

    def [](name)
      raise ConfigurationError.new("Unknown setting '#{name}'") if !SETTING_LIST.include?(name.to_s)

      @settings[name]
    end
    
    def []=(name, value)
      raise ConfigurationError.new("Unknown setting '#{name}'") if !SETTING_LIST.include?(name.to_s)

      @settings[name] = value
    end

    #def method_missing(name, *args, &block)
    #  name_s = name.to_s.gsub(/=$/, '')
    #
    #  raise ConfigurationError.new("Unknown setting '#{name_s}'") if !SETTING_LIST.include?(name_s)
    #
    #  if name.to_s != name_s
    #    @settings[name_s.intern] = args.first
    #  else
    #    @settings[name_s.intern]
    #  end
    #end
  end
end
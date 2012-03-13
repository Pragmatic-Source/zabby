# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011-2012 Farzad FARID
# License:: Simplified BSD License

# Configuration setting
module Zabby
  class Config
    SETTING_LIST = %w{server user password proxy_host proxy_user proxy_password}

    # Initialize Zabby configuration settings
    # @todo Anything to configure here?
    def initialize
      # TODO Anything to configure here?
    end

    # Display configuration variables
    def list
    puts "Zabby configuration"
    puts "==================="
      SETTING_LIST.each do |k|
        puts "#{k} = #{instance_variable_get("@#{k}")}"
      end
      nil
    end

    # Dynamic setter and getter methods for the configuration variables.
    # @param [String] name Setting name, ending with "=" in case we are setting a value
    # @param [Array] args Setting value
    # @param [Proc] block Unused
    # @return [Object] Return the value set
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
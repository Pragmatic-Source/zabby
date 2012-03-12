# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011 Farzad FARID
# License:: Simplified BSD License

module Zabby
  # Useful helper methods for the Zabbix Shell. Methods added to this module
  # are available in the scripting language and commande line.
  # The following instance variable should be available to helper methods:
  # - @config: Zabby::Config instance
  # - @connection: Zabby::Connection instance
  module ShellHelpers
    # XXX I don't like this hack anymore..
    ## Meta-create methods with the same name as the configuration settings.
    ## This way we can write:
    ##   set host "http://my.zabbix.server"
    ## instead of:
    ##   set :host => "http://my.zabbix.server"
    ## or "set host" instead of "set :host"
    ## All the created method does is return the second form which will be
    ## used by "set".
    #Zabby::Config::SETTING_LIST.each { |setting|
    #  # TODO.rdoc: Ruby 1.8 does not support default values for block arguments..
    #  # Writing "... do |value = nil|" would be more elegant.
    #  define_method(setting) do |*args|
    #    if args.empty?
    #      setting.intern
    #    else
    #      { setting.intern => args.first }
    #    end
    #  end
    #}

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
    alias_method :loggedin?, :logged_in?

    def version
      Zabby::VERSION
    end
  end
end
# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011-2012 Farzad FARID
# License:: Simplified BSD License

module Zabby
  # Useful helper methods for the Zabbix Shell. Methods added to this module
  # are available in the scripting language and commande line.
  # The following instance variable should be available to helper methods:
  # - @config: Zabby::Config instance
  # - @connection: Zabby::Connection instance
  module ShellHelpers
    # Documentation for helpers.
    # Each helper method definition must be preceded by a call to "desc" and a short
    # online help for the method.
    @helpers_doc = {}
    @last_doc = nil

    # Save the documentation for a method about to be defined.
    # @param text [String] Documentation of the method following the call to "desc"
    def self.desc(text)
      @last_doc = text
    end

    # Push helper documentation for the method just defined in a hash.
    # @param [Symbol] method Helper method to document
    # @todo Display functions in alphabetical or arbitrary order.
    def self.method_added(method)
      if @last_doc.nil?
        @helpers_doc[method.id2name] = "** UNDOCUMENTED FUNCTION **"
      else
        @helpers_doc[method.id2name] = @last_doc
        @last_doc = nil
      end
    end

    # Show the Shell helpers documentation
    def self.helpers_doc
      help = <<EOT
Available commands:
==================

EOT
      @helpers_doc.each do |name, text|
        help += name + ":\n"
        help += '-' * name.size + "\n"
        help += text + "\n\n"
      end
      help
    end

    desc %q{Set or query Zabby parameters.
- "set" without argument displays all parameters.
- "set <param>" shows the value of <param>
- "set <param> => <value>" set <param> to <value>}
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

    desc %q{Login to the Zabbix server.
The parameters 'server', 'user' and 'password' must be defined.}
    def login
      @connection.login(@config)
    end

    desc 'Logout from the Zabbix server'
    def logout
      @connection.logout
    end

    desc 'Return true if we are connected to the Zabbix server, false otherwise.'
    def logged_in?
      @connection.logged_in?
    end

    desc 'Alias for "logged_in?".'
    alias_method :loggedin?, :logged_in?

    desc 'Show Zabby version.'
    def version
      Zabby::VERSION
    end

    desc 'Return the list of available Zabbix Classes (object types).'
    def zabbix_classes
      Zabby::ZClass.zabbix_classes
    end

    desc 'Show this help text.'
    def help
      puts Zabby::ShellHelpers.helpers_doc
    end
  end
end
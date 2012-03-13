# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011 Farzad FARID
# License:: Simplified BSD License

module Zabby
  # Create Zabbix classes as provided by the Zabbix API
  module ZClass
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # List of valid Web Service methods for the current Zabbix Object
      attr_reader :zmethods

      # Name of the current class without the namespace
      # @return [String]
      # @example
      #   Zabby::Host.object_name => "host"
      def object_name
        @object_name ||= self.name.gsub(/^.*::/, '').downcase
      end

      # Add the list of Web Service methods to the current class.
      # @param [Array] zmethods Method names
      # @example
      #   class Host
      #     include ZClass
      #     add_zmethods :create, :delete, :exists, :get, :update
      #   end
      def add_zmethods(*zmethods)
        @zmethods = zmethods.map { |f| f.to_sym }
      end

      # Simulate methods on the object and call the Zabbix Web Service ("host.get", "item.create", etc.).
      # See http://www.zabbix.com/documentation/1.8/api for the API documentation.
      # @param [String] zmethod Name of the Web Service methods
      # @param [Array] args Method arguments
      # @param [Proc] block Unused
      # @raise [NoMethodError] Raised on invalid method names.
      def method_missing(zmethod, *args, &block)
        if @zmethods.include? zmethod
          Zabby::Runner.instance.connection.perform_request(object_name, zmethod, args.first)
        else
          super
        end
      end

      # Human representation of the Zabbix Class
      # @return [String] Class representation
      # @example
      #   Host.inspect => "<Zabbix Object 'host', methods: create, delete, exists, get, update>"
      def inspect
        "<Zabbix Object '#{object_name}', methods: #{@zmethods.join(', ')}>"
      end
    end
  end

  # Create all Zabbix object types and theirs methods.

  class Action
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class Alert
    include ZClass
    add_zmethods :create, :delete, :get
  end

  class APIInfo
    include ZClass
    add_zmethods :version
  end

  class Application
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :massAdd, :update
  end

  class Event
    include ZClass
    add_zmethods :acknowledge, :create, :delete, :get
  end

  class Graph
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class Graphitem
    include ZClass
    add_zmethods :get
  end

  class History
    include ZClass
    add_zmethods :delete, :get
  end

  class Host
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class Hostgroup
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :massAdd, :massRemove, :massUpdate, :update
  end

  class Image
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class Item
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class Maintenance
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class Map
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class Mediatype
    include ZClass
    add_zmethods :create, :delete, :get, :update
  end

  class Proxy
    include ZClass
    add_zmethods :get
  end

  class Screen
    include ZClass
    add_zmethods :create, :delete, :get, :update
  end

  class Script
    include ZClass
    add_zmethods :create, :delete, :execute, :get, :update
  end

  class Template
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :massAdd, :massRemove, :massUpdate, :update
  end

  class Trigger
    include ZClass
    add_zmethods :addDependencies, :create, :delete, :deleteDependencies, :exists, :get, :update
  end

  class User
    include ZClass
    add_zmethods :addMedia, :authenticate, :create, :delete, :deleteMedia, :get, :login, :logout, :update, :updateMedia, :updateProfile
  end

  class Usergroup
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :massAdd, :massRemove, :massUpdate, :update
  end

  class Usermacro
    include ZClass
    add_zmethods :createGlobal, :deleteGlobal, :deleteHostMacro, :get, :massAdd, :massRemove, :massUpdate, :updateGlobal
  end

  class Usermedia
    include ZClass
    add_zmethods :get
  end

end

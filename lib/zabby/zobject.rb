# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011 Farzad FARID
# License:: Simplified BSD License

module Zabby
  # Definition of the Zabbix Objects as provided by the Zabbix API
  class ZObject
    attr_reader :zname, :zmethods

    def initialize(zname, zmethods)
      @zname = zname
      @zmethods = zmethods.map { |f| f.to_sym }
    end

    # Simulate methods on the object.
    # For example: "host.get", "item.create"..
    # @zmethods is the list of valid methods.
    def method_missing(zmethod, *args, &block)
      if @zmethods.include? zmethod
        Zabby::Runner.instance.connection.perform_request(@zname, zmethod, args.first)
      else
        super
      end
    end
  end
end
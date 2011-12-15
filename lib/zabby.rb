# -*- encoding: utf-8 -*-

require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'

require 'zabby/version'
require 'zabby/exceptions'
require 'zabby/config'
require 'zabby/connection'
require 'zabby/runner'

module Zabby
  def self.init &block
    Zabby::Runner.new &block
  end
end

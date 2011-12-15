# -*- encoding: utf-8 -*-

require "rubygems"
require "json"
require "net/http"
require "net/https"
require "openssl"
require "uri"
require 'zabby/version'
require "zabby/exceptions"
require "zabby/connection"

module Zabby
  def self.init api_uri
    Zabby::Connection.new(api_uri)
  end
end

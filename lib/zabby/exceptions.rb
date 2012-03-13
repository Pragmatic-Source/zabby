# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011 Farzad FARID
# License:: Simplified BSD License

module Zabby
  class APIError < StandardError
    attr_reader :code, :msg, :data

    def initialize(msg, code = nil, data = nil)
      @msg = msg
      @code = code
      @data = data
    end

    def message
      text = "#{msg}"
      text += ": #{data}" if data
      text += " (code: #{code})" if code
      text
    end
  end
  class ResponseCodeError < APIError; end
  class AuthenticationError < APIError; end
  class ConfigurationError < StandardError; end
end

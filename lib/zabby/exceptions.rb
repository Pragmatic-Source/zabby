# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011 Farzad FARID
# License:: Simplified BSD License

module Zabby
  class ResponseCodeError < StandardError; end
  class AuthenticationError < StandardError; end
  class ConfigurationError < StandardError; end
end
$:.unshift File.expand_path('../lib', __FILE__)

require 'rspec'

RSpec.configure do |c|
  c.mock_with :rspec
end

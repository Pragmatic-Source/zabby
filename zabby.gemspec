# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zabby/version"

Gem::Specification.new do |s|
  s.name        = "zabby"
  s.version     = Zabby::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Farzad FARID"]
  s.email       = ["ffarid@pragmatic-source.com"]
  s.homepage    = "http://zabby.org/"
  s.summary     = %q{Ruby Zabbix API and command line interface}
  s.description = %q{Zabby is a Zabby API and CLI. It provides a provisioning tool for
creating, updating and querying Zabbix objects (hosts, items, triggers, etc.) through the web
service.}

  s.rubyforge_project = "zabby"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "json_pure"
  s.add_development_dependency "bundler", ">= 1.0.0"
end

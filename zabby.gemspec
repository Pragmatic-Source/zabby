# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011 Farzad FARID
# License:: Simplified BSD License

$:.push File.expand_path("../lib", __FILE__)
require "zabby/version"

Gem::Specification.new do |s|
  s.name        = "zabby"
  s.version     = Zabby::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Farzad FARID"]
  s.email       = ["ffarid@pragmatic-source.com"]
  s.homepage    = "http://zabby.org/"
  s.summary     = %q{Ruby Zabbix API, scripting language and command line interface}
  s.description = %q{Zabby is a Zabby API and CLI. It provides a provisioning tool for
creating, updating and querying Zabbix objects (hosts, items, triggers, etc.) through the web
service.}
  s.license     = "Simplified BSD"

  s.rubyforge_project = "zabby"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = [ "TODO.rdoc", "ChangeLog.rdoc" ]
  s.add_runtime_dependency "json"
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", ">= 2.0.0"
  s.add_development_dependency "rake", ">= 0.8.7"
  s.add_development_dependency "yard"
end

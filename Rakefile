require 'bundler'
require 'yard'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
  # File list is defined in '.yardopts'
  #t.files   = ['lib/**/*.rb', '-', 'LICENSE', 'TODO.rdoc', 'ChangeLog.rdoc']
  #t.options = ['--any', '--extra', '--opts'] # optional
end

task :default => [ :yard, :install ]
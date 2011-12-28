require 'bundler'
require 'yard'
Bundler::GemHelper.install_tasks

YARD::Rake::YardocTask.new do |t|
  # File list is defined in '.yardopts'
  #t.files   = ['lib/**/*.rb', '-', 'LICENSE', 'TODO.rdoc', 'ChangeLog.rdoc']
  #t.options = ['--any', '--extra', '--opts'] # optional
end

task :default => [ :yard, :install ]
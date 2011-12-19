require 'bundler'
require 'yard'
Bundler::GemHelper.install_tasks

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', '-', 'LICENSE']
  #t.options = ['--any', '--extra', '--opts'] # optional
end
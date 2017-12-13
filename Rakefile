# Rakefile
#require_relative './app'
require 'rake'
require 'rake/testtask'
#require 'sinatra/activerecord/rake'

Rake::TestTask.new do |t|
  t.pattern = "tests/**/*_test.rb"
end

task default: :test

# -*- Ruby -*-
require 'rake/testtask'
require 'rake/extensiontask'
require 'rubygems/package_task'

Rake::ExtensionTask.new('byebug')

SO_NAME = "byebug.so"

desc "Run new MiniTest tests."
task :test do
  Rake::TestTask.new(:test) do |t|
    t.test_files = FileList["test/*_test.rb"]
    t.verbose = true
  end
end

desc "Test everything - same as test."
task :check => :test

base_spec = eval(File.read('byebug.gemspec'), binding, 'byebug.gemspec')

# Rake task to build the default package
Gem::PackageTask.new(base_spec) do |pkg|
  pkg.need_tar = true
end

task :default => :test
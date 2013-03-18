# -*- encoding: utf-8 -*-
require 'rubygems'
require File.dirname(__FILE__) + "/lib/byebug/version"

Gem::Specification.new do |s|
  s.name = %q{byebug}
  s.version = Byebug::VERSION
  s.authors = ["David Rodríguez"]
  s.email = "deivid.rodriguez@mail.com"
  s.homepage = "http://github.com/deivid-rodriguez/byebug"
  s.summary = %q{Ruby 2.0 fast debugger - base + cli}
  s.description = %q{Byebug is a Ruby 2.0 debugger. It's implemented using the
    Ruby 2.0 TracePoint C API. The C extension was forked from debase whereas
    the rest of the gem was forked from debugger. The core component provides
    support that front-ends can build on. It provides breakpoint handling,
    bindings for stack frames among other things.
}
  s.required_rubygems_version = ">= 1.3.6"
  s.extra_rdoc_files = [ "README.md" ]
  s.files = `git ls-files`.split("\n")
  s.extensions << "ext/byebug/extconf.rb"
  s.executables = ["rdebug"]
  s.add_dependency "columnize", ">= 0.3.1"
  s.add_dependency "debugger-linecache", '~> 1.2.0'
  s.add_development_dependency 'rake', '~> 10.0.3'
  s.add_development_dependency 'rake-compiler', '~> 0.8.3'
  s.add_development_dependency 'mocha', '~> 0.13.3'
  s.license = "BSD"
end
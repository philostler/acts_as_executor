# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_executor/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_executor"
  s.version     = ActsAsExecutor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Phil Ostler"]
  s.email       = ["philostler@gmail.com"]
  s.homepage    = "https://github.com/philostler/acts_as_executor"
  s.summary     = %q{Java Executor framework integration for Rails}
  s.description = %q{Seamless integration of Java's Executor framework with JRuby on Rails}

  s.files         = Dir["**/*.rb"] + Dir["*.rdoc"] + Dir["LICENSE"] + Dir["*.gemspec"]
  s.require_paths = ["lib"]
end
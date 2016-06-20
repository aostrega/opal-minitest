# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'opal/minitest/version'

Gem::Specification.new do |s|
  s.name         = 'opal-minitest'
  s.version      = Opal::Minitest::VERSION
  s.summary      = 'Minitest, now for Opal!'
  s.description  = 'Minitest test runner for Opal'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/aostrega/opal-minitest'
  s.author       = 'Artur Ostrega'
  s.email        = 'artur@ostrega.me'

  s.files = `git ls-files`.split("\n")

  s.require_paths = ['lib']

  s.add_dependency 'opal', '>= 0.8'
  s.add_dependency 'rake', '~> 10'
  s.add_development_dependency 'minitest', '5.3.4'
end


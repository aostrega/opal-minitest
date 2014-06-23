# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'opal/minitest/version'

Gem::Specification.new do |s|
  s.name         = 'opal-minitest'
  s.version      = Opal::Minitest::VERSION
  s.author       = 'Artur Ostrega'
  s.email        = 'artur.mariusz.ostrega@gmail.com'
  s.summary      = 'MiniTest for Opal'
  s.description  = 'MiniTest test runner for Opal'

  s.files = `git ls-files`.split("\n")
  s.files << 'opal/opal/minitest/minitest.js'

  s.require_paths  = ['lib']

  s.add_dependency 'opal', '~> 0.6.2'
  s.add_dependency 'rake', '~> 10.3.2'
  s.add_development_dependency 'minitest', '5.3.2'
end


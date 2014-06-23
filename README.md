# opal-minitest

Opal port/utilities for MiniTest.

## Status

Currently supports:

* Core classes
* Test (except parallel running, plugins and CLI options)
* Assertions (except #capture_subprocess_io)

Any differences from vanilla Minitest are documented with an `OMT` label.

## Usage

Add the gem to a project's Gemfile.

`gem 'opal-minitest'`

Use the Rake task to headlessly runs a project's tests.

```ruby
# Rakefile
require 'opal/minitest/rake_task'
Opal::Minitest::RakeTask.new(:default)
```

`$ bundle exec rake`

This will require standard test_helper and test files and then run all tests.

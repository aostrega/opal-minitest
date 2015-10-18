# opal-minitest

Minitest, now for Opal!

## Usage

First, add the `opal-minitest` gem to a project's Gemfile.

```ruby
# Gemfile
gem 'opal-minitest'
```

`$ bundle install`

Include the Rake task in a Rakefile, then run `rake` to run the project's tests.

```ruby
# Rakefile
require 'opal/minitest/rake_task'
Opal::Minitest::RakeTask.new
```

`$ bundle exec rake`

This will run all Ruby/Opal files ending in `_test` in the `test/` directory, after an optional `test_helper` file. Try the example!

## Status

Opal Minitest can do everything regular Minitest can, except parallel running, plugins, CLI options, and `#capture_subprocess_io`.

All code differences from regular Minitest are documented with the label `PORT`.

# opal-minitest

Minitest, now for Opal!

## Usage

First, add the `opal-minitest` gem to an Opal project's Gemfile.

```ruby
# Gemfile
gem 'opal-minitest'
```

`$ bundle install`

Then, include the Rake task in a Rakefile. Finally, run `rake` to run the project's tests.

```ruby
# Rakefile
require 'opal/minitest/rake_task'
Opal::Minitest::RakeTask.new
```

`$ bundle exec rake`

This will run all files ending in `_test.(rb|opal)` in the `test/` directory, after an optional `test_helper.(rb|opal)` file. Try the example!

## Status

Opal Minitest supports everything that normal Minitest does, except parallel test running, plugins, CLI options, and `#capture_subprocess_io`.

All code differences from normal Minitest are documented with the label `PORT`.

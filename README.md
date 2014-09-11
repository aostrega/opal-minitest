# opal-minitest

Minitest, now for Opal!

## Usage

First, add the `opal-minitest` gem to a project's Gemfile.

```ruby
# Gemfile
gem 'opal-minitest'
```

`$ bundle install`

Finally, use the included Rake task to headlessly run the project's tests.

```ruby
# Rakefile
require 'opal/minitest/rake_task'
Opal::Minitest::RakeTask.new(name: :default)
```

`$ bundle exec rake`

This will run all Ruby/Opal files ending in `_test` in the `test/` directory, after an optional `test_helper` file in the same directory. Try the example!

## Status

Opal Minitest can currently do everything regular Minitest can, except parallel running, plugins, CLI options, and `#capture_subprocess_io`.

Any code differences in the port from regular Minitest are documented with an `OMT` label.

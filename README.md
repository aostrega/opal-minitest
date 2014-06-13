# opal-minitest

MiniTest utility for Opal.

It supplies a Rake task that runs a Ruby project's tests through Opal.

```ruby
# Rakefile
require 'opal/minitest/rake_task'

Opal::MiniTest::RakeTask.new(:default)
```

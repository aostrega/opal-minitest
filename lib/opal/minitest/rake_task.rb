require 'opal/minitest'

module Opal
  module MiniTest
    class RakeTask
      include Rake::DSL

      PORT = 2838
      RUNNER = File.expand_path('../../../../vendor/runner.js', __FILE__)

      def initialize(name = 'opal:minitest')
        desc "Run MiniTest tests through Opal"
        task(name) do
          require 'rack'
          require 'webrick'

          server = fork {
            Rack::Server.start(app: Server.new, Port: PORT, server: 'webrick')
          }

          #system "phantomjs #{RUNNER} \"http://localhost:#{PORT}\""

          #Process.kill(:SIGINT, server)
          #Process.wait
        end
      end

      class Server < Opal::Server
        def initialize
          super

          use_gem 'minitest'
          $LOAD_PATH.each { |p| append_path(p) }
          append_path 'test'
          self.main = 'opal/minitest/loader'
        end
      end
    end
  end
end

require 'rake'
require 'opal/minitest'

module Opal
  module Minitest
    class RakeTask
      include Rake::DSL

      RUNNER_PATH = File.expand_path('../../../../vendor/runner.js', __FILE__)

      def initialize(args = {})
        args = defaults.merge(args)

        desc "Run tests through opal-minitest"
        task(args[:name]) do
          require 'rack'
          require 'webrick'
          require 'tilt/erb'

          server = fork {
            Rack::Server.start(
              app: Server.new(requires_glob: args[:requires_glob]),
              Port: args[:port],
              server: 'webrick',
              Logger: WEBrick::Log.new('/dev/null'),
              AccessLog: [])
          }

          unless system "phantomjs -v"
            raise "phantomjs command not found"
          end

          system "phantomjs", RUNNER_PATH, "http://localhost:#{args[:port]}"

          Process.kill(:SIGINT, server)
          Process.wait
        end
      end

      private

      def defaults
        {
          name: 'default',
          port: 2838,
          requires_glob: 'test/{test_helper,**/*_test}.{rb,opal}'
        }
      end

      class Server < Opal::Server
        attr_reader :requires_glob

        def initialize(args)
          gem_path = Pathname.new(__FILE__).join('../../../..')
          self.index_path = gem_path.join('opal/opal/minitest/runner.html.erb').to_s

          super

          $omt_requires_glob = args.fetch(:requires_glob)

          $LOAD_PATH.each { |p| append_path(p) }
          append_path 'test'
          self.main = 'opal/minitest/loader'
          self.debug = false
        end
      end
    end
  end
end

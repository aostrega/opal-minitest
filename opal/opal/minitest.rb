require 'opal/minitest/version'
require 'opal/minitest/core_classes'

module Opal
  module Minitest
    mc = (class << self; self; end)
    mc.send :attr_accessor, :backtrace_filter

    ##
    # This is the top-level run method. Everything starts from here. It
    # tells each Runnable sub-class to run, and each of those are
    # responsible for doing whatever they do.
    #
    # The overall structure of a run looks like this:
    #
    #   Minitest.autorun
    #     Minitest.run(args)
    #       Minitest.__run(reporter, options)
    #         Runnable.runnables.each
    #           runnable.run(reporter, options)
    #             self.runnable_methods.each
    #               self.run_one_method(self, runnable_method, reporter)
    #                 Minitest.run_one_method(klass, runnable_method, reporter)
    #                   klass.new(runnable_method).run

    def self.run args = []
      options = process_args args

      reporter = CompositeReporter.new
      reporter << SummaryReporter.new(options[:io], options)
      reporter << ProgressReporter.new(options[:io], options)

      reporter.start
      __run reporter, options
      reporter.report

      reporter.passed?
    end

    ##
    # Internal run method. Responsible for telling all Runnable
    # sub-classes to run.

    def self.__run reporter, options
      suites = Runnable.runnables.shuffle
      suites.each { |s| s.run reporter, options }
    end

    def self.process_args args = [] # :nodoc:
      {
        io: $stdout,
        seed: srand % 0xFFFF,
        #args: args.map { |s| s =~ /[\s|&<>$()]/ ? s.inspect : s }.join " "
      }
    end

    self.backtrace_filter = BacktraceFilter.new

    def self.run_one_method klass, method_name # :nodoc:
      result = klass.new(method_name).run
      raise "#{klass}#run _must_ return self" unless klass === result
      result
    end
  end
end

# shim
Minitest = Opal::Minitest

require "opal/minitest/test"

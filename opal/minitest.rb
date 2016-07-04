# PORT: unsupported
#require "optparse"
#require "thread"
#require "mutex_m"
#require "minitest/parallel"

# PORT: added
require "minitest/core_classes"

##
# :include: README.txt
module Minitest
  VERSION = "5.3.4.opal" # :nodoc:

  @@installed_at_exit ||= false
  @@after_run = []
  @extensions = []

  mc = (class << self; self; end)

  ##
  # Parallel test executor
  # PORT: unsupported

  #mc.send :attr_accessor, :parallel_executor
  #self.parallel_executor = Parallel::Executor.new((ENV['N'] || 2).to_i)

  ##
  # Filter object for backtraces.

  mc.send :attr_accessor, :backtrace_filter

  ##
  # Reporter object to be used for all runs.
  #
  # NOTE: This accessor is only available during setup, not during runs.

  mc.send :attr_accessor, :reporter

  ##
  # Names of known extension plugins.
  # PORT: unsupported

  #mc.send :attr_accessor, :extensions

  ##
  # Registers Minitest to run at process exit
  # PORT: unsupported

#  def self.autorun
#    at_exit {
#      next if $! and not ($!.kind_of? SystemExit and $!.success?)
#
#      exit_code = nil
#
#      at_exit {
#        @@after_run.reverse_each(&:call)
#        exit exit_code || false
#      }
#
#      exit_code = Minitest.run ARGV
#    } unless @@installed_at_exit
#    @@installed_at_exit = true
#  end

  ##
  # A simple hook allowing you to run a block of code after everything
  # is done running. Eg:
  #
  #   Minitest.after_run { p $debugging_info }

  def self.after_run &block
    @@after_run << block
  end

  # PORT: unsupported
  #def self.init_plugins options # :nodoc:
  #  self.extensions.each do |name|
  #    msg = "plugin_#{name}_init"
  #    send msg, options if self.respond_to? msg
  #  end
  #end

  # PORT: unsupported
  #def self.load_plugins # :nodoc:
  #  return unless self.extensions.empty?

  #  seen = {}

  #  require "rubygems" unless defined? Gem

  #  Gem.find_files("minitest/*_plugin.rb").each do |plugin_path|
  #    name = File.basename plugin_path, "_plugin.rb"

  #    next if seen[name]
  #    seen[name] = true

  #    require plugin_path
  #    self.extensions << name
  #  end
  #end

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
    # PORT: removed
    #self.load_plugins

    options = process_args args

    reporter = CompositeReporter.new
    reporter << SummaryReporter.new(options[:io], options)
    reporter << ProgressReporter.new(options[:io], options)

    self.reporter = reporter # this makes it available to plugins
    # PORT: removed
    #self.init_plugins options
    self.reporter = nil # runnables shouldn't depend on the reporter, ever

    reporter.start
    __run reporter, options
    # PORT: removed
    #self.parallel_executor.shutdown
    reporter.report

    reporter.passed?
  end

  ##
  # Internal run method. Responsible for telling all Runnable
  # sub-classes to run.
  #
  # NOTE: this method is redefined in parallel_each.rb, which is
  # loaded if a Runnable calls parallelize_me!.

  def self.__run reporter, options
    suites = Runnable.runnables.shuffle
    parallel, serial = suites.partition { |s| s.test_order == :parallel }

    # If we run the parallel tests before the serial tests, the parallel tests
    # could run in parallel with the serial tests. This would be bad because
    # the serial tests won't lock around Reporter#record. Run the serial tests
    # first, so that after they complete, the parallel tests will lock when
    # recording results.
    serial.map { |suite| suite.run reporter, options } +
      parallel.map { |suite| suite.run reporter, options }
  end

  def self.process_args args = [] # :nodoc:
    options = {
               :io => $stdout,
              }
    orig_args = args.dup

    # PORT: unsupported
#    OptionParser.new do |opts|
#      opts.banner  = "minitest options:"
#      opts.version = Minitest::VERSION
#
#      opts.on "-h", "--help", "Display this help." do
#        puts opts
#        exit
#      end
#
#      opts.on "-s", "--seed SEED", Integer, "Sets random seed" do |m|
#        options[:seed] = m.to_i
#      end
#
#      opts.on "-v", "--verbose", "Verbose. Show progress processing files." do
#        options[:verbose] = true
#      end
#
#      opts.on "-n", "--name PATTERN","Filter run on /pattern/ or string." do |a|
#        options[:filter] = a
#      end
#
#      unless extensions.empty?
#        opts.separator ""
#        opts.separator "Known extensions: #{extensions.join(', ')}"
#
#        extensions.each do |meth|
#          msg = "plugin_#{meth}_options"
#          send msg, opts, options if self.respond_to?(msg)
#        end
#      end
#
#      begin
#        opts.parse! args
#      rescue OptionParser::InvalidOption => e
#        puts
#        puts e
#        puts
#        puts opts
#        exit 1
#      end
#
#      orig_args -= args
#    end

    unless options[:seed] then
      srand
      options[:seed] = srand % 0xFFFF
      orig_args << "--seed" << options[:seed].to_s
    end

    srand options[:seed]

    options[:args] = orig_args.map { |s|
      s =~ /[\s|&<>$()]/ ? s.inspect : s
    }.join " "

    options
  end

  def self.filter_backtrace bt # :nodoc:
    backtrace_filter.filter bt
  end

  ##
  # PORT: section moved to core_classes.rb
  ##

  self.backtrace_filter = BacktraceFilter.new

  def self.run_one_method klass, method_name # :nodoc:
    result = klass.new(method_name).run
    raise "#{klass}#run _must_ return self" unless klass === result
    result
  end
end

require "minitest/test"
# PORT: unsupported
#require "minitest/unit" unless defined?(MiniTest) # compatibility layer only

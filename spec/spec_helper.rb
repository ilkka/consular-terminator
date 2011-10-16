require 'spork'

Spork.prefork do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require 'rspec'
  require 'mocha'

  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|
  end

  require 'tempfile'

  class EmptyTermfile < Tempfile
    def initialize
      super('consular')
      write(%q(setup "echo 'setup'"))
      rewind
    end
  end
end

Spork.each_run do
  require 'consular/terminator'
end


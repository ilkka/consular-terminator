require 'consular'
require 'rbconfig'

module Consular
  # Consular core for interacting with Terminator
  #
  class Terminator

    Consular.add_core self

    class << self
      # Check to see if current system is valid for this core
      #
      # @api public
      def valid_system?
        ((RbConfig::CONFIG['host_os'] =~ /linux/) != nil) &&
          !`which xdotool`.chomp.empty?
      end
    end
  end
end

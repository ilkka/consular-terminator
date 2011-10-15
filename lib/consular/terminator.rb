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
        if (RbConfig::CONFIG['host_os'] =~ /linux/) != nil
          if !(xdotool = `which xdotool`.chomp).empty?
            begin
              return File::Stat.new(xdotool).executable?
            rescue
              return false
            end
          end
        end
        return false
      end
    end
  end
end

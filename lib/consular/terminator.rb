require 'consular'
require 'rbconfig'

module Consular
  # Consular core for interacting with Terminator.
  #
  # Since we don't have any real API to work with and just send
  # keypresses via XTEST, we don't have tab references either.
  # Instead we just count tabs and return tab indexes.
  #
  # Largely adapted from http://github.com/achiu/consular-osx
  class Terminator < Core

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

    # Initialize
    #
    # @param [String] path
    #   path to Termfile.
    #
    # @api public
    def initialize(path)
      super
      @tabidx = nil
    end

    # Method called by runner to Execute Termfile setup.
    #
    # @api public
    def setup!
      @termfile[:setup].each { |cmd| execute_command(cmd, :in => active_window) }
    end

    # Method called by runner to execute Termfile.
    #
    # @api public
    def process!
      windows = @termfile[:windows]
      default = windows.delete('default')
      execute_window(default, :default => true) unless default[:tabs].empty?
      windows.each_pair { |_, cont| execute_window(cont) }
    end

    # Executes the commands for each designated window.
    # .run_windows will iterate through each of the tabs in
    # sorted order to execute the tabs in the order they were set.
    # The logic follows this:
    #
    #   If the content is for the 'default' window,
    #   then use the current active window and generate the commands.
    #
    #   If the content is for a new window,
    #   then generate a new window and activate the windows.
    #
    #   Otherwise, open a new tab and execute the commands.
    #
    # @param [Hash] content
    #   The hash contents of the window from the Termfile.
    # @param [Hash] options
    #   Addional options to pass. You can use:
    #     :default - Whether this is being run as the default window.
    #
    # @example
    #   @core.execute_window contents, :default => true
    #   @core.execute_window contents, :default => true
    #
    # @api public
    def execute_window(content, options = {})
      window_options = content[:options]
      _contents      = content[:tabs]
      _first_run     = true

      _contents.keys.sort.each do |key|
        _content = _contents[key]
        _options = content[:options]
        _name    = options[:name]

        _tab =
        if _first_run && !options[:default]
          open_window options.merge(window_options)
        else
          key == 'default' ? nil : open_tab(_options)
        end

        _first_run = false
        commands = prepend_befores _content[:commands], _contents[:befores]
        commands = set_title _name, commands
        commands.each { |cmd| execute_command cmd, :in => _tab }
      end

    end

    # Prepend a title setting command prior to the other commands.
    #
    # @param [String] title
    #   The title to set for the context of the commands.
    # @param [Array<String>] commands
    #   The context of commands to preprend to.
    #
    # @api public
    def set_title(title, commands)
      cmd = "PS1=\"$PS1\\[\\e]2;#{title}\\a\\]\""
      title ? commands.insert(0, cmd) : commands
    end

    # Prepends the :before commands to the current context's
    # commands if it exists.
    #
    # @param [Array<String>] commands
    #   The current tab commands
    # @param [Array<String>] befores
    #   The current window's :befores
    #
    # @return [Array<String>]
    #   The current context commands with the :before commands prepended
    #
    # @api public
    def prepend_befores(commands, befores = nil)
      unless befores.nil? || befores.empty?
        commands.insert(0, befores).flatten! 
      else
        commands
      end
    end

    # Execute the given command in the context of the
    # active window.
    #
    # @param [String] cmd
    #   The command to execute.
    # @param [Hash] options
    #   Additional options to pass into appscript for the context.
    #
    # @example
    #   @osx.execute_command 'ps aux', :in => @tab_object
    #
    # @api public
    def execute_command(cmd, options = {})
      run_in_active_terminator cmd, options
    end

    # Opens a new tab and return the last instantiated tab(itself).
    #
    # @param [Hash] options
    #   Options to further customize the window. You can use:
    #     :settings -
    #     :selected -
    #
    # @return
    #   Returns a refernce to the last instantiated tab of the
    #   window.
    #
    # @api public
    def open_tab(options = nil)
      send_keypress(active_terminator_window, "ctrl+shift+t")
    end

    # Opens a new window and returns its
    # last instantiated tab.(The first 'tab' in the window).
    #
    # @param [Hash] options
    #   Options to further customize the window. You can use:
    #     :bound        - Set the bounds of the windows
    #     :visible      - Set whether or not the current window is visible
    #     :miniaturized - Set whether or not the window is minimized
    #
    # @return
    #   Returns a refernce to the last instantiated tab of the
    #   window.
    #
    # @api public
    def open_window(options = nil)
      send_keypress(active_terminator_window, "ctrl+shift+i")
      return (@tabidx = 0)
    end

    private

    # Send keypresses to window winid
    #
    # @api private
    def send_keypress(winid, keys)
      xdotool("windowfocus #{winid}")
      xdotool("key #{keys}")
    end

    # Run command with active terminator
    #
    # @api private
    def run_in_active_terminator(cmd, options = {})
      type_in_window(active_terminator_window, cmd)
    end

    # Get active terminator window winid.
    # Gets the active window and returns it if it is
    # a Terminator window. If it is not a terminator window,
    # the method gets all terminator windows and returns the
    # first one. If no terminator windows exist, aborts.
    #
    # @api private
    def active_terminator_window
      active = xdotool("getactivewindow").chomp
      if not all_terminator_windows.include? active
        active = all_terminator_windows.first
      end
      if not active
        abort("No Terminator windows found")
      end
      return active
    end

    # Get window IDs of all terminator windows.
    #
    # @api private
    def all_terminator_windows
      xdotool("search --onlyvisible --class terminator").split("\n")
    end

    # Type text in window winid.
    #
    # @api private
    def type_in_window(winid, text)
      xdotool("windowfocus #{winid}")
      xdotool("type \"#{text}\"")
    end

    # Execute xdotool with the given args and return output
    #
    # @api private
    def xdotool(cmd)
      IO.popen("xdotool #{cmd}").read
    end
  end
end

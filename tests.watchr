#!/usr/bin/env watchr
# vim:ft=ruby

def have_notify_send?
  case `which notify-send`.empty?
  when true
    false
  else
    true
  end
end

def have_growl?
  @have_growl ||= begin
                    require 'growl'
                  rescue LoadError
                    false
                  end
end

def error_icon_name 
  "gtk-dialog-error"
end

def success_icon_name
  "gtk-dialog-info"
end

# Rules
watch('^spec/.+_spec\.rb$') { |md| spec md[0] }
watch('^lib/.+\.rb$') { |md| spec "spec/#{File.basename(md[0]).gsub(/\..*?$/, '')}_spec.rb" }
watch('^features/.+\.feature$') { |md| feature md[0] }
watch('^features/step_definitions/(.+)_steps\.rb$') { |md| feature "features/#{md[1]}.feature" }

# Notify using notify-send.
#
# @param icon [String] name of stock icon to use.
# @param title [String] title of notification.
# @param message [String] message for notification body.
# @return [Boolean] true if the command ran successfully, false
# otherwise.
def notify(icon, title, message)
  system("notify-send -t 3000 -i #{icon} \"#{title}\" \"#{message}\"")
end

# Notify of success.
#
def notify_success
  puts "Success"
  if have_notify_send?
    notify success_icon_name, "All green!", "Now write more tests :)"
  elsif have_growl?
    Growl.notify_ok "All green!"
  end
end

# Notify of failure.
#
def notify_failure
  puts "Failure"
  if have_notify_send?
    notify error_icon_name, "Something is broken", "Now go fix it :)"
  elsif have_growl?
    Growl.notify_error "Something is broken"
  end
end

# Run a single ruby command. Notify appropriately.
# 
# @param cmd [String] command to run.
def run(cmd)
  system('clear')
  puts "Running #{cmd}"
  if system(cmd)
    notify_success
    true
  else
    notify_failure
    false
  end
end

# Run a single spec.
#
# @param specfiles [String] path to specfile or [Array] of paths.
def spec(specfiles)
  specs = case specfiles.respond_to? :join
             when true
               specfiles.join(" ")
             when false
               specfiles
             end
  if run(%Q(rspec #{specs}))
    if @last_run_failed
      @last_run_failed = false
      run_all_specs
    end
  else
    @last_run_failed = true
  end
  !@last_run_failed
end

# Run a single feature.
#
# @param featurefiles [String] path to feature file or [Array] of paths.
def feature(featurefiles)
  features = case featurefiles.respond_to? :join
             when true
               featurefiles.join(" ")
             when false
               featurefiles
             end
  run(%Q(cucumber #{features}))
end

# Run all specs.
#
def run_all_specs
  spec Dir['spec/*_spec.rb']
end

# Run all features.
#
def run_features
  feature Dir['features/*.feature']
end

# Run specs and features.
#
def run_suite
  run_all_specs && run_features
end

# Run all specs on Ctrl-\
Signal.trap('QUIT') { run_all_specs }

# Run full suite on one Ctrl-C, quit on two
@interrupted = false
Signal.trap('INT') do
  if @interrupted
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    run_suite
    @interrupted = false
  end
end


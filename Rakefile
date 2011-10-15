require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rcov = true
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

require 'yard'
YARD::Rake::YardocTask.new

task :default => [:features, :rspec]


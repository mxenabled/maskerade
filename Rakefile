require "bundler"
require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"

task :default => [:rubocop, :spec]

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)

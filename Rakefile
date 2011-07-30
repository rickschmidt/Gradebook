require 'rake'
require 'rubygems'
#require "rspec/core/rake_task" # RSpec 2.0

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:cache_empty)do |t|
  	t.pattern = FileList['spec/gradebook/utility/*_spec.rb']
	t.rspec_opts = ['--tag cache_empty']
end

RSpec::Core::RakeTask.new(:cache_collect)do |t|
  	t.pattern = FileList['spec/gradebook/utility/*_spec.rb']
	t.rspec_opts = ['--tag cache_collects']
end
task :default => :spec
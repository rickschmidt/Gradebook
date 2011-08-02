require 'rake'
require 'rubygems'
require 'rspec/core/rake_task'

#Default is to run all tests in spec folder

RSpec::Core::RakeTask.new(:spec)do |t|
	t.pattern=FileList['spec/gradebook/']
end
task :default => :spec

RSpec::Core::RakeTask.new(:utility)do |t|
  	t.pattern = FileList['spec/gradebook/utility/*_spec.rb']
end

#Runs Utility::Base examples while continuously purging the caches.
# run 'rake cache_empty'
RSpec::Core::RakeTask.new(:cache_empty)do |t|
  	t.pattern = FileList['spec/gradebook/utility/base_spec.rb']
	t.rspec_opts = ['--tag cache_empty']
end

#Runs Utility::Base examples while collecting a cache.
# run 'rake cache_collect'
RSpec::Core::RakeTask.new(:cache_collect)do |t|
  	t.pattern = FileList['spec/gradebook/utility/base_spec.rb']
	t.rspec_opts = ['--tag cache_collects']
end

RSpec::Core::RakeTask.new(:function)do |t|
  	t.pattern = FileList['spec/gradebook/utility/function_spec.rb']
end

RSpec::Core::RakeTask.new(:structure)do |t|
  	t.pattern = FileList['spec/gradebook/utility/structure_spec.rb']
end




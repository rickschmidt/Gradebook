$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
gem 'gdata2'
require 'aruba/cucumber'
include Gradebook
Before('@slow_process') do
  @aruba_io_wait_seconds = 10
end
# Before do
#   @aruba_timeout_seconds = 10
# 
# end



When /^I run the new category command is given with the name of a new category as a param$/ do
#    user_grades=Gradebook::Usergrades.new
 #   user_grades.new_category('cuke-cucumbertest')
end

When /^the remove category command is given with the name of a category as a param$/ do
   # user_grades=Gradebook::Usergrades.new
  #  user_grades.remove_category('cuke-cucumbertest')
end

When /^I am grading all$/ do
	@user_grades=Gradebook::Usergrades.new
	num_of_students=@user_grades.number_of_students
	puts "num #{num_of_students}"
	for i in (1..23)
		type("CukeB#{i}")
	end
	# $stdin<ARGV.pop
	puts "Done grading all"

	
end

When /^I send an interrupt$/ do
	exit_requested = false
	Kernel.trap( "INT" ) { exit_requested = true }
	puts "exiting"
end




AfterStep('@slow') do
  @aruba_io_wait_seconds = 3
end
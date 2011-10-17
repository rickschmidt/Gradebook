$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
gem 'gdata2'
require 'aruba/cucumber'
include Gradebook

Before('@slow_process') do
  @aruba_io_wait_seconds = 15
end
Before do
  @aruba_timeout_seconds = 20

end


Then /^CucumberTest should exist as a column header$/ do
	@client=Gradebook::Client.new
	@function=Gradebook::Utility::Function.new(@client)
	@function.search_for_column_id("CucumberTest").should_not eql(nil)
end


	


When /^I am grading all$/ do
	@user_grades=Gradebook::Usergrades.new
	num_of_students=@user_grades.number_of_students
	puts "num #{num_of_students.to_i}"
	for i in (1..num_of_students.to_i)
		type("CukeB#{i}")
	end
	# $stdin<ARGV.pop
	puts "Done grading all"

	
end






AfterStep('@slow') do
  @aruba_io_wait_seconds = 6

end
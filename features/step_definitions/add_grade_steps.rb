$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'gradebook'

Given /^a gradebook$/ do

  @client=Gradebook::Client.new
  @client.setup('','')
  sps_id=@client.get_course("XML")
  etag=@client.sps_get_etag("",sps_id)
  puts etag
  
end

When /^I send the grade all command$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^ask what category this grade should be filed under$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^add a column for the category to the gradebook$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^start presenting students names and prompt for grade\.$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^after each grade is entered print the students name and grade as confirmation\.$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^continue until all students have been had their grades done\.$/ do
  pending # express the regexp above with the code you wish you had
end

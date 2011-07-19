$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'gdata'
include Gradebook

Given /^an authenticated client and a spreadsheet ID$/ do
    @client=Gradebook::Client.new()
    @client.setup("","")
    @sps_id= Search.sps_get_course(@client.doc_client,"Roster")
end

When /^the new category command is given with the name of a new category as a param$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^check to see if an average column for the new category prefix exists$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^present the user with options Y or N to update the column\.$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^if the answer is Y re\-average the column\.$/ do
  pending # express the regexp above with the code you wish you had
end

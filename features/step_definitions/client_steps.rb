$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'gradebook'

Given /^a client$/ do
  @client=Gradebook::Client.new
end

When /^I send it the authenticate message$/ do
    @client.setup("","")
  
end

Then /^I should have a successful authenticaion object response$/ do
  @client.doc_client.should_not eql(nil)
end



When /^authentication fails$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^there should be an error$/ do
  pending # express the regexp above with the code you wish you had
end

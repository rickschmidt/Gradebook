Given /^an authenticated doc_client$/ do
  @client=Gradebook::Client.new
  @client.setup("","")
  @client.doc_client.should_not eql(nil)
  @client.sps_client.should_not eql(nil)    

end



When /^I send the create command with a course name create a spreadsheet on gdocs$/ do
    @book=Gradebook::Book.new(@client.doc_client,@client.sps_client)
    @course="Cucumber"
    @book.create(@client.doc_client,"Cucumber")
end

Then /^return the id of the newly created document$/ do
    @book.get_course("Cucumber")
end

Then /^delete that newly created test document$/ do
  id=@book.get_course("Cucumber")
  @book.delete_course_with_id(id)
end


Given /^an authenticated doc_client and no course name$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I send the create commnad without a course name created a spreadsheet called "([^"]*)" with a timestamp\.$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end



Given /^a course search term$/ do

end

When /^I send the get_course\(course\) message$/ do
    @client=Gradebook::Client.new
    @client.setup("","")
  @create=Gradebook::Book.new(@client.doc_client,@client.sps_client)
  @doc_id=@create.get_course("xml")
  puts @doc_id
    @doc_id.should_not eql(nil)
end

Then /^return an id of the first matched spreadsheet$/ do

end

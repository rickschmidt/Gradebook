Given /^an authenticated client$/ do
    @gcl=Gradebook::GoogleCL.new

end

Given /^a course name$/ do
    @course="Cucumber"
end

When /^I receive the create command$/ do
    @gcl.upload(File.expand_path('../../../sample/roster.csv', __FILE__))
end



When /^I use the the list command$/ do
  @gcl.list
end



When /^I use the get command with a Doc Title and path for download$/ do
    @gcl.get("Cucumber", File.expand_path('../../../sample/download.csv'))

end



When /^I use the delete command with google cl and a specific google doc name$/ do
    @gcl.delete("Cucumber")
end




$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "Client" do
    
   before(:all) do
       @client=Gradebook::Client.new
       @client.setup("","")
     end
       
     it "should should have a doc_client and a sps_client after setup" do
         @client.doc_client.should_not eql(nil)
         @client.sps_client.should_not eql(nil)
     end
     
     
     
     it "should be able to get an etag given a course name" do
         sps_id=@client.sps_get_course("Roster")
         tag=@client.sps_get_etag('',sps_id)
         tag.should_not eql(nil)
     end
     
     it "shold be able to calculate how many columns are in the spreadsheet for the purpose of knowing where to put a new category column" do
        colCount=@client.get_colCount
        puts "Number of columns #{colCount}"
     end
     
     it "should be able to calculate how many rows are in the spreadsheet" do
        rowCount=@client.get_rowCount
        puts "Number of rows #{rowCount}" 
     end
     
     it "should be able to add a category" do
#         @client.add_category("Q4")
         @client.get_row("1")
     end
     
 end
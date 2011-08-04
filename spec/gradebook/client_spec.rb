
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
         @client.add_category("Q4")
         used_columns=@client.get_number_of_used_columns
         
     end
     
     it "should be able to add a column to the spreadsheet by changing the sheets metadata when no more columns are API accessible" do
        @client.add_column(1)
     end
     
     it "should be able to search for a row by the student id column" do
        @client.search_for_sid("2222") 
     end
     
     it "should be able to get the version number of the worksheet in a spreadsheet feed " do
         sps_id=@client.sps_get_course("Roster")
        version=@client.sps_get_version(sps_id) 
        puts "version is #{version}"
     end
     

     
 end
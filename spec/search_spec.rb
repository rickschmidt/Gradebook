
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "Search" do
    
   before(:all) do
       @client=Gradebook::Client.new
       @client.setup("","")
       @sps_id= Search.sps_get_course(@client.doc_client,"Roster")
     end
     
     it "shoulbe be able to get a course and then the doc id and in turn this also tests extracting the id" do
        result=Gradebook::Search.sps_get_course(@client.doc_client,"Roster")
        result.should_not eql(nil)        
    end
    
     it "should be able to search with sid" do
         result=Gradebook::Search.search_with_sid(1111,@sps_id,@client.sps_client)
         result.should_not eql(nil)         
     end
     
     it "should be able to serach for a sid " do
        result=Gradebook::Search.search_for_sid("mary",@sps_id,@client.sps_client) 
        result.should_not eql(nil)
     end
     
     it "should be able to search for and return a  sid" do
        result=Gradebook::Search.search_for_and_return_sid("mary",@sps_id,@client.sps_client)
        result.should_not eql(nil)
     end
     
     it "should be able to get the header row" do
        result=Gradebook::Search.get_columns_headers(@client.sps_client,@sps_id)
        result.should_not eql(nil)
     end         
    
    it "should be able to serach for a column id" do
        headers=Search.get_columns_headers(@client.sps_client,@sps_id)
        result=Gradebook::Search.search_for_column_id("name",headers) 
    end
    
    
 end
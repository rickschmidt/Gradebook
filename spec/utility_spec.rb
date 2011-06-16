$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "Utility" do
    
   before(:all) do
       @client=Gradebook::Client.new
       @client.setup('','')
       @sps_id=Gradebook::Search.sps_get_course(@client.doc_client,"Roster")
       @sheet=Gradebook::Search.sps_get_sheet(@client.sps_client,@sps_id)
       @rows=Gradebook::Search.sps_get_rows(@client.sps_client,@sps_id)
     end
     
     it "should be able to get a specific sheet from a spreadsheet" do
        sps_id=Gradebook::Search.sps_get_course(@client.doc_client,"Roster")
        sheet=Gradebook::Search.sps_get_sheet(@client.sps_client,sps_id).should_not eql(nil)
     end
     
     it "should be able to add a column" do
         
       Gradebook::Utility.get_number_of_used_columns(@rows).should_not eql(nil)  
     end
     
    it "should be able to add a category" do
        Gradebook::Utility.add_category(@client.sps_client,@sps_id,"Test 3",@rows,@sheet).should_not eql(nil)
     end
     
     it "should be able to extract the document id from the feed" do
         should fail
         Gradebook::Search.extract_document_id_from_feed(feed,entry).should_not eql(nil)
     end
     
     it "should be able to get the number of columns" do
         Gradebook::Utility.get_number_of_columns(@sheet).should_not eql(nil)
     end
     
     it "should be able to get the number of used columns" do
         Gradebook::Utility.get_number_of_used_columns(@sheet).should_not eql(nil)
     end
     
     it "should make sure that the number of columns and the number of used columns are reasonable" do
         total=Gradebook::Utility.get_number_of_columns(@sheet)
         total.should_not eql(nil)
         used=Gradebook::Utility.get_number_of_used_columns(@sheet)
         used.should_not eql(nil)
         puts "Total is a #{total.class}: Used is a #{used.class}"
         used.should be <= total 
         
         
     end
     
     it "should be able to get the row count" do
         Gradebook::Utility.get_number_of_rows(@sps_id,@sheet).should_not eql(nil)
     end

     it "should be able to get a course" do
         should fail
     end
          
     it "should be able to get the spreadsheet by course name" do
         should fail
     end
     
     it "should be able to get the etag of spreadsheet" do
         Gradebook::Utility.sps_get_etag(@client.sps_client,@sps_id).should_not eql(nil)
     end
     
     it "should be able to get the version of a spreadsheet" do
         should fail
        Gradebook::Utility.sps_get_version(@client.sps_client,@sps_id).should_not eql(nil)
        
     end
 end


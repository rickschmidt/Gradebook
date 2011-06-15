$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "Utility" do
    
   before(:all) do
       @client=Gradebook::Client.new
       @client.setup('','')
       

     end
       
     it "should be able to add a column" do
         sps_id=Gradebook::Search.sps_get_course(@client.doc_client,"Roster")
         sheet=Gradebook::Search.sps_get_sheet(@client.sps_client,sps_id)
       Gradebook::Utility.get_number_of_used_columns(sheet)  
     end
     
    it "should be able to add a category" do
         sps_id=Gradebook::Search.sps_get_course(@client.doc_client,"Roster")
         sheet=Gradebook::Search.sps_get_sheet(@client.sps_client,sps_id)
        Gradebook::Utility.add_category(@client.sps_client,sps_id,"Test 3",sheet)
     end
     
     it "should be able to extract the document id from the feed" do
         should fail
         Gradebook::Search.extract_document_id_from_feed(feed,entry)
     end
     
     it "should be able to get the number of columns" do
        sps_id=Gradebook::Search.sps_get_course(@client.doc_client,"Roster")
        sheet=Gradebook::Search.sps_get_sheet(@client.sps_client,sps_id)
         Gradebook::Utility.get_number_of_columns(sheet)
     end
     
     it "should be able to get a course" do
         should fail
     end
     
     it "should be able to get the number of used columns" do
        sps_id=Gradebook::Search.sps_get_course(@client.doc_client,"Roster")
        sheet=Gradebook::Search.sps_get_sheet(@client.sps_client,sps_id)
         Gradebook::Utility.get_number_of_used_columns(sheet)
     end
     
     it "should be able to get the row count" do
         sps_id=Gradebook::Search.sps_get_course(@client.doc_client,"Roster")
        sheet=Gradebook::Search.sps_get_sheet(@client.sps_client,sps_id)
         Gradebook::Utility.get_number_of_rows(sps_id,sheet)
     end
     
     it "should be able to get the spreadsheet by course name" do
         should fail
     end
     
     it "should be able to get the etag of spreadsheet" do
         sps_id=Gradebook::Search.sps_get_course(@client.doc_client,"Roster")
        sheet=Gradebook::Search.sps_get_sheet(@client.sps_client,sps_id)
         Gradebook::Utility.sps_get_etag(@client.sps_client,sps_id)
     end
     
     it "should be able to get a specific sheet from a spreadsheet" do
         should fail
     end
     
     it "should be able to get the version of a spreadsheet" do
         should fail
     end
     
     #add_category   add_column   extract_document_id_from_feed   get   get_colCount   get_course   
     #get_number_of_used_columns   get_rowCount   new   post   put   search_for_sid   setup   
     #sps_get_course   sps_get_etag   sps_get_sheet   sps_get_version  
 end


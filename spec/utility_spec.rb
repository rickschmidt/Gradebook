$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'
include Gradebook

describe "Utility" do
    context "general low level interactions" do
       before(:each) do
           @client= Client.new
           @client.setup('','')
           @sps_id= Search.sps_get_course(@client.doc_client,"Roster")
           @sheet= Search.sps_get_sheet(@client.sps_client,@sps_id)
           @rows= Search.sps_get_rows(@client.sps_client,@sps_id)
         end
     
         it "should be able to get a specific sheet from a spreadsheet" do
            sps_id= Search.sps_get_course(@client.doc_client,"Roster")
            sheet= Search.sps_get_sheet(@client.sps_client,sps_id).should_not eql(nil)
         end
     
         it "should be able to add a column" do
             before_num_of_cols= Utility.get_number_of_columns(@sheet)
              Utility.add_column(1,@client.sps_client,@sheet,@sps_id)
             after_num_of_cols= Utility.get_number_of_columns(@sheet)
             
                after_num_of_cols.should eql(before_num_of_cols+1)
         end
         
         it "should be able to remove a column" do
             before_num_of_cols=Utility.get_number_of_columns(@sheet)
             
             Utility.remove_columns(1,@client.sps_client,@sheet,@sps_id)
             after_num_of_cols=Utility.get_number_of_columns(@sheet)
             
                after_num_of_cols.should eql(before_num_of_cols-1)
         end
     
        it "should be able to add a category" do
             Utility.add_category(@client.sps_client,@sps_id,"Test 3",@rows,@sheet).should_not eql(nil)
         end
     
         it "should be able to extract the document id from the feed" do
             should fail
              Search.extract_document_id_from_feed(feed,entry).should_not eql(nil)
         end
     
         it "should be able to get the number of columns" do
              Utility.get_number_of_columns(@sheet).should_not eql(nil)
         end
     
         it "should be able to get the number of used columns" do
              Utility.get_number_of_used_columns(@rows).should_not eql(nil)
              puts Utility.get_number_of_used_columns(@rows)
         end
     
         it "should make sure that the number of columns and the number of used columns are reasonable" do
             total= Utility.get_number_of_columns(@sheet)
             total.should_not eql(nil)
             used= Utility.get_number_of_used_columns(@sheet)
             used.should_not eql(nil)
             used.should be <= total 
         
         end
     
         it "should be able to get the row count" do
              Utility.get_number_of_rows(@sps_id,@sheet).should_not eql(nil)
         end

         it "should be able to get a course" do
             should fail
         end
          
         it "should be able to get the spreadsheet by course name" do
             should fail
         end
     
         it "should be able to get the etag of spreadsheet" do
              Utility.sps_get_etag(@client.sps_client,@sps_id).should_not eql(nil)
         end
     
         it "should be able to get the version of a spreadsheet" do
             should fail
             Utility.sps_get_version(@client.sps_client,@sps_id).should_not eql(nil)
        
         end
    end
    
    context "a professor wants to add a new grade category to a sheet that does not have enough columns" do
        before(:each) do
            @client= Client.new
            @client.setup('','') #This would normally be a username password.  A dev account 'gradebookluc' is currently hard coded
            @sps_id= Search.sps_get_course(@client.doc_client,"Roster")
            @sheet= Search.sps_get_sheet(@client.sps_client,@sps_id)
            @rows= Search.sps_get_rows(@client.sps_client,@sps_id)
        end
        
        it "should be able to get the number of columns " do
             num_of_cols= Utility.get_number_of_columns(@sheet)
             num_of_cols.should_not eql(nil)
             num_of_used_cols= Utility.get_number_of_used_columns(@rows)

         if num_of_cols>num_of_used_cols
             num_to_remove=num_of_cols-num_of_used_cols
             Utility.remove_columns(num_to_remove,@client.sps_client,@sheet,@sps_id)
             num_of_cols= Utility.get_number_of_columns(@sheet)
             num_of_used_cols= Utility.get_number_of_used_columns(@rows)
             num_of_used_cols.should eql(num_of_cols)
         end
        end
            
        it "should then add another column to the spreadsheet by updating the metadata" do
            Utility.add_column(1,@client.sps_client,@sheet,@sps_id)
        end
    end
end
         



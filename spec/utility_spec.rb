$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'
include Gradebook


describe "Utility" do
    context "general low level interactions" do
       before(:each) do
          @base=Utility::Base.new
#           @sheet=Utility::Base.sps_get_sheet(@client.sps_client,@sps_id)
 #          @rows=Utility::Base.get_list_feed(@client.sps_client,@sps_id)

         end
     
         it "should be able to get a specific sheet from a spreadsheet" do
#            sps_id= Utility::Base.sps_get_course(@client.doc_client,"Roster")
            sheet=@base.sps_get_sheet.should_not eql(nil)
         end
     
         it "should be able to add a column" do
             before_num_of_cols=@base.get_number_of_columns
             sheet=@base.sps_get_sheet
             @structure=Utility::Structure.new
             @structure.add_columns(1,sheet,@structure.sps_id)
             after_num_of_cols=@base.get_number_of_columns
             after_num_of_cols.should eql(before_num_of_cols+1)            
         end
         
         it "should test" do
#              set_trace_func proc { |event, file, line, id, binding, classname|
#   printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
# }
            @structure=Utility::Structure.new
             puts @structure.inspect
             puts "var #{@structure.sps_id}"
#             puts @structure.instance_variable_get(:@sps_id)
         end
         
         it "should be able to remove a column" do
             before_num_of_cols=Utility.get_number_of_columns(@sheet)             
             Utility.remove_columns(1,@client.sps_client,@sheet,@sps_id)
             after_num_of_cols=Utility.get_number_of_columns(@sheet)             
             after_num_of_cols.should eql(before_num_of_cols-1)
         end
     
        it "should be able to add a category" do
             result=Utility.add_category(@client.sps_client,@sps_id,"t-rspec",@rows,@sheet)
             result.should_not eql(nil)
         end
     

     
         it "should be able to get the number of columns" do
              result=Utility.get_number_of_columns(@sheet)
              result=result.to_i
              result.should_not eql(nil)
         end
     
         it "should be able to get the number of used columns" do
              result=Utility.get_number_of_used_columns(@rows)
              result.should_not eql(nil)
              
              
         end
     
         it "should make sure that the number of columns and the number of used columns are reasonable" do
             total= Utility.get_number_of_columns(@sheet)
             total.should_not eql(nil)
             used= Utility.get_number_of_used_columns(@sheet)
             used.should_not eql(nil)
             used.should be <= total 
         
         end
     
         it "should be able to get the row count" do
              result=Utility.get_number_of_rows(@sps_id,@sheet).should_not eql(nil)
              result.should_not eql(nil)
              
         end
         
         it "should be able to get the number of used rows" do
            result=Utility.get_number_of_used_rows(@client.sps_client,@sps_id).should_not eql(nil) 
            result.should_not eql(nil)
            
         end
          
         it "should be able to get the spreadsheet by course name" do
           @sps_id=Utility.sps_get_course(@client.doc_client,"Roster")
           @sps_id.should_not eql(nil)
         end
     
     
         
         it "should be able to get the list feed of a spreadsheet" do
           result=Utility.get_list_feed(@client.sps_client,@sps_id)
           result.should_not eql(nil)
           
         end
         
         it "should be able to get the average of a category" do
            result=Utility.category_average(@client.sps_client,@sps_id,'3') 
            result.should_not eql(nil)
            
         end
         
         it "should be able to create a new entry" do
            Utility.new_entry.should_not eql(nil) 
         end
         
         it "should be able to remove a category by searching for one" do
           # Utility.add_category(@client.sps_client,@sps_id,"t-rspec2",@rows,@sheet)            
            result=Utility.remove_category(@client.sps_client,@sps_id,"t-rspec2") 
            puts result
            result.should_not eql(nil)            
         end
         
        #  it "should be able to get the number of rows from the cell feed" do
        #     result=Utility.num_of_rows_cell_feed(@client.sps_client,@sps_id)
        #     puts result.cla
        #     result.should_not eql(nil)
        #     
        # end
        
        it "should be able to get the category weights from sheet two using a sq on the list feed" do
           result=Utility.get_category_weights(@client.sps_client,@sps_id,2) 
           result.should_not eql(nil)
           
        end
        
        it "should be able to return a weight code for a category" do
           result=Utility.get_weight_code_for_category("q-Q3")            
           result.should_not eql(nil)
           
        end
        
        it "should be able to ge the points possible for a category" do        
           result=Utility.get_possible_points_for_category(@client.sps_client,@sps_id,"hw-hw1") 
           result.should_not eql(nil)
           
        end
        
        it "should be able to get a sheet" do
           result=Utility.sps_get_sheet(@client.sps_client,@sps_id) 
           result.should_not eql(nil)
        end
        
        it "should be able to get the cell feed " do
           result=Utility.get_cell_feed(@client.sps_client,@sps_id,'single','')
           result.should_not eql(nil) 
        end
        
        it "should be able to get the column headers " do
           result=Utility.get_columns_headers(@client.sps_client,@sps_id)
           result.should_not eql(nil) 
        end
        
        it "should be able to get the etag from the list feed " do
           result=Utility.get_etag_list_feed(@rows)
           result.should_not eql(nil) 
        end
        
        it "should be able to create a batch entry" do
            result=Utility.new_batch_entry
            result.should_not eql(nil) 
        end
        
        it "should be able to create a new entry" do
           result=Utility.new_entry
           result.should_not eql(nil) 
        end
        
        it "should be able to remove a column " do
            result=Utility.remove_columns(1,@client.sps_client,@sheet,@sps_id)         
            result.shold_not eql(nil)
        end
        
         it "should be able to search for and return a  sid" do
            result=Utility.search_for_and_return_sid("mary",@sps_id,@client.sps_client)
            result.should_not eql(nil)
         end
     
         it "should be able to serach for a column id" do
             headers=Utility.get_columns_headers(@client.sps_client,@sps_id)
             result=Utility.search_for_column_id("name",headers) 
             result.should_not eql(nil)             
         end
    
        it "should be able to search with sid" do
             result=Utility.search_with_sid(1111,@sps_id,@client.sps_client)
             result.should_not eql(nil)         
         end
     
         it "should be able to serach for a sid " do
            result=Utility.search_for_sid("mary",@sps_id,@client.sps_client) 
            result.should_not eql(nil)
         end
     
         it "should be able to get the etag for the sheet " do
            result=Utility.sps_get_etag_sheet(@client.sps_client,@sps_id,@rows,1)
             result.should_not eql(nil)
         end
         
         it "should do this" do
             params="&min-col=#{36}&max-col=#{36}"
                        url="https://spreadsheets.google.com/feeds/cells/#{@sps_id}/1/private/full?prettyprint=true#{params}"
                 y=@client.sps_client.get(url)
            puts "y is #{y.inspect}" 
         end
     
     
    end
    
    context "a professor wants to add a new grade category to a sheet that does not have enough columns" do
        before(:each) do
            @client= Client.new
            @client.setup('','') #This would normally be a username password.  A dev account 'gradebookluc' is currently hard coded
            @sps_id= Utility.sps_get_course(@client.doc_client,"Roster")
            @sheet= Utility.sps_get_sheet(@client.sps_client,@sps_id)
            @rows= Utility.get_list_feed(@client.sps_client,@sps_id)

        end
        
        it "should be able to get the number of columns " do
                should fail
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
            Utility.add_columns(1,@client.sps_client,@sheet,@sps_id)
        end
        
        it "sps_get_course" do
           Utility.sps_get_course(@client.doc_client,"documents") 
        end
    end
end
         



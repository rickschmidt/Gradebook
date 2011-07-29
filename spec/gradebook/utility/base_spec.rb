require 'spec_helper.rb'
include Gradebook
include Utility
    
describe "Base" do
	context "can do general low level interactions with an accumulating tmp directory and " do
		before(:each) do
			@base=Utility::Base.new
		end
		
		
     
		it "should be able to get a specific sheet from a spreadsheet" do
			@base.sps_get_sheet.should be_a_kind_of(REXML::Document)
        end
         
         it "should be able to the get the number of columns" do
 			@base.get_number_of_columns.should be_a_kind_of(Integer)	
		end
		
		it "should get the number of used columns" do
			@base.get_number_of_used_columns.should be_a_kind_of(Integer)		  
		end
		
		it "should get the number of rows" do
			@base.get_number_of_rows.should be_a_kind_of(Integer)		  
		end
		
		it "should get the number of used rows" do
			@base.get_number_of_used_rows.should be_a_kind_of(Integer)		  		  
		end
		
		it "should be able to get the etag from the sheet" do
			@base.sps_get_etag_sheet(1).should be_a_kind_of(String)		  
		end
		
		it "should get the etag from the list feed" do
		  	@base.get_etag_list_feed.should be_a_kind_of(String)
		end
		
		
		
		it "should get the numbers of ros in a cell feed" do
			
		end
		
		it "should get the cell feed" do
			@base.get_cell_feed('rspec','&max-row=3').should be_a_kind_of(REXML::Document)			
			@base.get_cell_feed('all','test').should be_a_kind_of(REXML::Document)					
		end
		
	
		
		it "should get the column headers" do
		  	@base.get_columns_headers.should be_a_kind_of(Hash)
		  	@base.get_columns_headers.should have_at_least(1).things			
		end
		
		it "should get a sheet" do
			@base.sps_get_sheet.should be_a_kind_of(REXML::Document)
		end
		
		it "should get the list feed with url params" do

			@base.get_list_feed('1','&sq=id').should be_a_kind_of(REXML::Document)

		end
		
		it "should get the possible points for a category" do
		  	points=@base.get_possible_points_for_category("hw-hw1")
			points.should be_a_kind_of(Integer)			
		end

     end

# context "can do general low level interactions clearingthe tmp directory and " do
# 		before(:each) do
# 			
# 			@base=Utility::Base.new 
# 		end
#      
# 		it "should be able to get a specific sheet from a spreadsheet" do
# 			@base.sps_get_sheet.should be_a_kind_of(REXML::Document)
#         end
#          
#          it "should be able to the get the number of columns" do
#  			@base.get_number_of_columns.should be_a_kind_of(Integer)	
# 		end
# 		
# 		it "should get the number of used columns" do
# 			@base.get_number_of_used_columns.should be_a_kind_of(Integer)		  
# 		end
# 		
# 		it "should get the number of rows" do
# 			@base.get_number_of_rows.should be_a_kind_of(Integer)		  
# 		end
# 		
# 		it "should get the number of used rows" do
# 			@base.get_number_of_used_rows.should be_a_kind_of(Integer)		  		  
# 		end
# 		
# 		it "should be able to get the etag from the sheet" do
# 			@base.sps_get_etag_sheet(1).should be_a_kind_of(String)		  
# 		end
# 		
# 		it "should get the etag from the list feed" do
# 		  	@base.get_etag_list_feed.should be_a_kind_of(String)
# 		end
# 		
# 		it "should get the list feed with empty url params" do
# 		  	@base.get_list_feed('',1).should be_a_kind_of(REXML::Document)
# 			@base.get_list_feed('&sq=id',1).should be_a_kind_of(REXML::Document)
# 		end
# 		
# 		it "should get the numbers of ros in a cell feed" do
# 			
# 		end
# 		
# 		it "should get the cell feed" do
# 			@base.get_cell_feed('rspec','&max-row=3').should be_a_kind_of(REXML::Document)			
# 			@base.get_cell_feed('all','').should be_a_kind_of(REXML::Document)					
# 		end
# 		
# 		it "should get the possible points for a category" do
# 		  	points=@base.get_possible_points_for_category("hw-hw1")
# 			points.should be_a_kind_of(Integer)			
# 		end
# 		
# 		it "should get the column headers" do
# 		  	@base.get_columns_headers.should be_a_kind_of(Hash)
# 		  	@base.get_columns_headers.should have_at_least(1).things			
# 		end
# 		
# 		it "should get a sheet" do
# 			@base.sps_get_sheet.should be_a_kind_of(REXML::Document)
# 		end
# 
#      end


 end


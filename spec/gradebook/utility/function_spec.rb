require 'spec_helper.rb'
include Gradebook
include Utility
    
describe "Function" do
	context "performs various functions on spreadsheet cells" do
		before(:all) do
			@client=Gradebook::Client.new
			@function=Function.new(@client)
		end
		
		it "should get the category average" 

		
		it "should get the weight code for a category" do
			@structure=Utility::Structure.new(@client)
			@structure.add_category("rspec")
			@function.get_weight_code_for_category("rspec").should_not eql(nil)
			@structure.remove_category("rspec").should_not eql(nil)
		end
		
		it "should search for a student ID using a name" do
		  	@function.search_for_sid("john").should_not eql(nil)
		end
		
		it "should search by student ID (SID) and return a hash of matches" do
		  	@function.search_for_and_return_sid("1111").should_not eql(nil)
		end
		
		it "should retrun the grades for a student by searching with their SID" do
		  	@function.search_with_sid("1111").should_not eql(nil)
		end
		
		it "should search for a column id" do
			@structure=Utility::Structure.new(@client)
			@structure.add_category("rspec")
		  	@function.search_for_column_id("rspec").should_not eql(nil)
		  	@structure.remove_category("rspec").should_not eql(nil)
		end
		
		it "should get the possible points for a category" do
			@structure=Utility::Structure.new(@client)
			@structure.add_category("rspec")
		  	@function.get_possible_points_for_category('rspec').should be_a_kind_of(Hash)
		
			@structure.remove_category("rspec").should_not eql(nil)
		end
	end
end
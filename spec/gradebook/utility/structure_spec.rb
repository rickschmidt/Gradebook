require 'spec_helper.rb'
include Gradebook
include Utility
    
describe "Structure" do
	context "can adjust the structure of the spreadsheet" do
		before(:all) do
			@client=Gradebook::Client.new
			@structure=Utility::Structure.new(@client)
		end
		
		it "should be able to add a column" do
			@structure.add_columns(1).should_not eql(nil)
		end
		
		it "should remove a column" do
		  @structure.remove_columns(1).should_not eql(nil)
		end
		
		it "should add a category" do
		  @structure.add_category("rspec").should_not eql(nil)
		end
		
		it "should remove a category" do
		  @structure.remove_category("rspec").should_not eql(nil)
		end
	
		
		it "creates a new entry" do
			Utility::Structure.new_entry.should be_a_kind_of(REXML::Element)
		end 
		
		
	end	
	
end
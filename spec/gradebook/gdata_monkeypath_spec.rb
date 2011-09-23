$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'
include Gradebook

describe "Monkeypatch" do
	it "should now be able to respond to 304 response code" do
		@client=Gradebook::Client.new
		@base=Gradebook::Utility::Base.new(@client)
		
		list_feed=@base.get_list_feed
		list_feed2=@base.get_list_feed
		

	end
	
	
	
end
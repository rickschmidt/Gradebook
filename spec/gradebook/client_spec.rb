
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "Client" do 
	before(:all) do
		@client=Gradebook::Client.new
	end
       
    it "should should have a doc_client and a sps_client after initialiaztion" do
		@client.doc_client.should_not eql(nil)
        @client.sps_client.should_not eql(nil)
    end
     
	it "should have authorization token in each client after initialization" do
		@client.doc_client.auth_handler.token.should_not eql(nil)
		@client.sps_client.auth_handler.token.should_not eql(nil)
	end
	
	it "should have a sps_id after initialization" do
		@client.sps_id.should_not eql(nil)
	end
	
	
	it "should be able to clear the credentials" 
		
	
	it "should be able to clear the sps_id" 
		

     
 end
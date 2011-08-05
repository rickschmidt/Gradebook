
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "Client" do
    
   before(:all) do
       @client=Gradebook::Client.new
     end
       
     it "should should have a doc_client and a sps_client after setup" do
        @client.doc_client.should_not eql(nil)
        @client.sps_client.should_not eql(nil)
		@client.sps_id.should_not eql(nil)
     end
     
	it "returns true when the ~/.gradebook does exist" do
		@client.stub(:preference?).and_return(true)

		@client.preference?.should eql(true)
	end
	
	it "returns false when the ~/.gradebook does not exist" do
		@client.stub(:preference?).and_return(false)
		@client.preference?.should eql(false)
	end
	
	it "should create the preference file if it needs to" do
		@client.create_preference.should_not eql(nil)
	end
	

     
     
 
     

     
 end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "Client" do
    
   before(:all) do
       @client=Gradebook::Client.new
       @client.setup("","")
     end
       
     it "should should have a doc_client and a sps_client after setup" do
         @client.doc_client.should_not eql(nil)
         @client.sps_client.should_not eql(nil)
     end
     
     
     
     
 end
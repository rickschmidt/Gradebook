$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'
include Gradebook

describe "Usergrades" do
    context "high level abstractions that test the 'grade all and grade by sid' functionality" do
       before(:each) do
           @client=Gradebook::Client.new
           @client.setup("","") 
           @sps_id= Search.sps_get_course(@client.doc_client,"Roster")
           @headers=Search.get_columns_headers(@client.sps_client,@sps_id)
           
         end
     
         it "should be able to grade all the students" do
            should fail
         end
         
         it "should be able to grade an individual student with the students SID as a paramter" do
             should fail
         end
     end
 end
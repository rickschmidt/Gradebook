$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'
include Gradebook

describe "Grade" do
    context "grading a student" do
       before(:each) do
           @client= Client.new
           @client.setup('','')
           @sps_id= Search.sps_get_course(@client.doc_client,"Roster")
       end
   
   
       it "should be able to get the first row ie. headers" do
          headers=Search.get_columns_headers(@client.sps_client,@sps_id)
          puts headers
       end
   end
end
   
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'
include Gradebook

describe "Grade" do
    context "grading a student" do
       before(:each) do
           @client= Client.new

           @sps_id= Search.sps_get_course(@client.doc_client,"Roster")
       end
   
   
       
       it "should ask for the category_id when the grade command is issued" do
         headers=Search.get_columns_headers(@client.sps_client,@sps_id)
         column_id=Search.search_for_column_id('Q1',headers)
         list_feed=Utility.get_list_feed(@client.sps_client,@sps_id)
         Grade.grade_each_student(@client.sps_client,@sps_id,list_feed,column_id)
         Grade.enter_grade(sps_client,sps_id,entry,column_id)
       end
       
       
   end
end
   
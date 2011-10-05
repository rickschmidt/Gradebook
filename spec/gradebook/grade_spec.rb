$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'
include Gradebook

describe "Grade" do
    context "grading a student" do
       before(:each) do
           @client= Client.new
		   @function=Gradebook::Utility::Function.new(@client)
       end
   
   
       
       it "should ask for the category_id when the grade command is issued" do
         headers=@function.get_columns_headers
         column_id=@function.search_for_column_id('Q1')
         list_feed=@function.get_list_feed(1,'')
		 @user_grades=Gradebook::Usergrades.new
		@user_grades.grade_by_sid('1111')
         Grade.enter_grade(entry,column_id)
       end
       
       
   end
end
   
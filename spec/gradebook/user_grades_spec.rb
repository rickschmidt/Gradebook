$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'
include Gradebook

describe "Usergrades" do
    context "high level abstractions that test the 'grade all and grade by sid' functionality" do
       before(:all) do
			@client=Gradebook::Client.new
           @function=Utility::Function.new(@client)
           @user_grades=Usergrades.new
         end
     
         it "should be able to grade all the students" do
            should fail
         end
         
         it "should be able to generate an xml report for an individiual student by SID" do
            ug=Usergrades.new
            ug.grade_report_xml(7777) 
         end
         
        it "should be able to generate an xml report for an individiual student their name" do
            ug=Usergrades.new
            ug.grade_report_by_name_xml("firstname","mary") 
         end
         
         it "should be able to grade an individual student with the students SID as a paramter" do
             should fail
         end
         
         it "should be able to add a student" do
            ug=Usergrades.new 
            ug.add_student
         end
         
         it "should extract the category weight" do
            ug=Usergrades.new
            ug.extract_category_weight_from_header 
         end
         
         it "should be able to average a category type per student" do
             ug=Usergrades.new
            ug.category_average_for_each_studnet
        end

		it "should be able to get the number of students" do
			@user_grades.number_of_students.should be_a_kind_of(Integer)

			
		end
        


     end
 end
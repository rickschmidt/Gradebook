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
            @user_grades.grade_all
         end
         
         it "should be able to generate an xml report for an individiual student by SID" do

            @user_grades.grade_report_xml(7777) 
         end
         
        it "should be able to generate an xml report for an individiual student their name" do
            @user_grades.grade_report_by_name_xml("firstname","mary") 
         end
         
         it "should be able to grade an individual student with the students SID as a paramter" do
			@user_grades.grade_by_sid(1111)
         end
         
         it "should be able to add a student" do
            @user_grades.add_student
         end
         
         it "should extract the category weight" do
            @user_grades.extract_category_weight_from_header 
         end
         
         it "should be able to average a category type per student" do
            @user_grades.category_average_for_each_studnet
        end

		it "should be able to get the number of students" do
			@user_grades.number_of_students.should be_a_kind_of(Integer)
		end
        
		it "should be able to get the name for the current sheet" 

     end
 end
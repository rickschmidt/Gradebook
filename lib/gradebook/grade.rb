require 'gdata'
require 'gradebook/search'
require 'gradebook/utility'


module Gradebook
   class Grade
     
     def self.grade_each_student(list_feed,column_id)
        list_feed.elements.each('entry') do |entry| 
          student_name=''
           entry.elements.each('gsx:name') do |name|
             student_name=name
             
           end
           puts "Students Name: #{student_name.text}"
           puts "Enter Grade for #{student_name.text}:"
            self.enter_grade
        end

     end
   
   
    def self.enter_grade
      
      
    end
   
   
   
   
   
       
   end 
end
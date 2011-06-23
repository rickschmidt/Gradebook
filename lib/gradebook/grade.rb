require 'gdata'
require 'gradebook/search'
require 'gradebook/utility'


module Gradebook
   class Grade
     
     def self.grade_each_student(sps_client,sps_id,list_feed,column_id)
        list_feed.elements.each('entry') do |entry| 
          student_name=''
           entry.elements.each('gsx:name') do |name|
             student_name=name
             
           end
           puts "Students Name: #{student_name.text}"
           puts "Enter Grade for #{student_name.text}:"
            self.enter_grade(sps_client,sps_id,entry,column_id)
        end

     end
   
   
     def self.enter_grade(sps_client,sps_id,entry,column_id)
         edit_uri=''
           entry.add_namespace('http://www.w3.org/2005/Atom')
            entry.add_namespace('gd','http://schemas.google.com/g/2005')
            entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
            entry.add_namespace('gsx','http://schemas.google.com/spreadsheets/2006/extended')
         entry.elements.each('link') do |link|
             edit_uri = entry.elements["link[@rel='edit']"].attributes['href']
             puts edit_uri
         end
         entry.elements.each("gsx:*[#{column_id}]") do |col|
             col.text="C"
         end
         #elements['gs:colCount'].text = "#{total_columns.to_i}"
         sps_client.put(edit_uri,entry.to_s)
    end
   
   
   
   
   
       
   end 
end
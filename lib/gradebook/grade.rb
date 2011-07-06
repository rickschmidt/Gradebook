require 'gdata'
require 'gradebook/search'
require 'gradebook/utility'


module Gradebook
   class Grade
       def initialize(sps_client,sps_id,column_id)
           @sps_client=sps_client
           @sps_id=sps_id
           @column_id=column_id
        end
     
        def grade_each_student(list_feed)
            list_feed.elements.each('entry') do |entry| 
                student_name=''
                entry.elements.each('gsx:name') do |name|
                    student_name=name 
                end
                puts "Students Name: #{student_name.text}"
                puts "Enter Grade for #{student_name.text}:"
                self.enter_grade(entry)
            end
        end
   
        def enter_grade(entry,grade)
            edit_uri=''
            puts "#{entry}"
            entry.add_namespace('http://www.w3.org/2005/Atom')
            entry.add_namespace('gd','http://schemas.google.com/g/2005')
            entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
            entry.add_namespace('gsx','http://schemas.google.com/spreadsheets/2006/extended')
            entry.elements.each('link') do |link|
                edit_uri = entry.elements["link[@rel='edit']"].attributes['href']
            end
            entry.elements.each("gsx:*[#{@column_id}]") do |col|
                col.text=grade
            end
            @sps_client.put(edit_uri,entry.to_s)
        end
   end 
end
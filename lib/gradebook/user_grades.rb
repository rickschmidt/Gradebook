require 'gdata'
include Gradebook
=begin rdoc
    A class that encapsulates the grading classes
=end
module Gradebook
    class Usergrades
        
        def initialize
           @client=Gradebook::Client.new
           @client.setup("","") 
           @sps_id= Search.sps_get_course(@client.doc_client,"Roster")
           @headers=Search.get_columns_headers(@client.sps_client,@sps_id)
        end
        
        def grade
            puts "Enter search term for grade category"
            category=STDIN.gets.chomp
            column_id=Gradebook::Search.search_for_column_id(category,@headers)
            list_feed=Utility.get_list_feed(@client.sps_client,@sps_id)
            

            list_feed.elements.each('entry') do |entry| 
                  student_name=''
                  score=''
                  entry.elements.each('gsx:name') do |name|
                      student_name=name
                      puts "Enter grade for student: #{student_name.text}"
                      score=STDIN.gets.chomp
                      
                  end
                     
                grade=Gradebook::Grade.new(@client.sps_client,@sps_id,column_id)
                grade.enter_grade(entry,score)
            end
                     
        end
        
        def grade_each
            puts "Enter search term for grade category"
            category=STDIN.gets.chomp
            column_id=Gradebook::Search.search_for_column_id(category,@headers)
            list_feed=Utility.get_list_feed(@client.sps_client,@sps_id)
            
            puts "What is the students name?"
            name=STDIN.gets.chomp
            Search.search_for_sid(name,@sps_id,@client.sps_client)
   
        end
        
    end
end
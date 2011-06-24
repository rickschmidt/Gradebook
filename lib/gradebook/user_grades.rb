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
            puts "Enter search term for grade categry"
            category=STDIN.gets.chomp
            column_id=Gradebook::Search.search_for_column_id(category,@headers)
            list_feed=Utility.get_list_feed(@client.sps_client,@sps_id)
            

            list_feed.elements.each('entry') do |entry| 
                  student_name=''
                  grade=''
                  entry.elements.each('gsx:name') do |name|
                      student_name=name
                      puts "Enter grade for student: #{student_name.text}"
                      grade=STDIN.gets.chomp
                      
                  end
                 Grade.enter_grade(@client.sps_client,@sps_id,entry,column_id,grade)
            end
                     
        end
        
    end
end
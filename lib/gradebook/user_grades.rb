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
        
        def grade_all
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
                puts "entry #{entry.class}, score: #{score}"
                grade.enter_grade(entry,score)
            end
                     
        end
        
        def grade_by_sid(sid)
            puts "Enter search term for grade category"
            category=STDIN.gets.chomp
            column_id=Gradebook::Search.search_for_column_id(category,@headers)
            #list_feed=Utility.get_list_feed(@client.sps_client,@sps_id)            
            list_feed=Search.search_with_sid(sid,@sps_id,@client.sps_client)
            list_feed.elements.each('entry') do |entry| 
                puts "Enter grade for student #{}"
                score=STDIN.gets.chomp
                grade=Gradebook::Grade.new(@client.sps_client,@sps_id,column_id)
                puts "entry #{entry.class}, score: #{score}"
                grade.enter_grade(entry,score)
            end
        end
        
    end
end
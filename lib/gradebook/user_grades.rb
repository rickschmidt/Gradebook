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

=begin rdoc
    Grades each student on the roster by first asking for and a category (column name) on the Gradebook.  Then each students name is presented and 
    waits for a grade to be entered for that student.
=end
        def grade_all
            puts "Enter search term for grade category"
            category=STDIN.gets.chomp
            puts "Searching for category... #{category}"
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
        
=begin rdoc
    Grades a single student for a single category.  After a category is identified the student is looked up by searhching for the SID (student ID) that is passed as a parameter.
    The name of the student that is found is revealed and the user then enters a grade for that student in the category provided.
=end
        
        def grade_by_sid(sid)
            puts "Enter search term for grade category"
            category=STDIN.gets.chomp
            puts "Searching for category... #{category}"
            column_id=Gradebook::Search.search_for_column_id(category,@headers)
            #list_feed=Utility.get_list_feed(@client.sps_client,@sps_id)            
            list_feed=Search.search_with_sid(sid,@sps_id,@client.sps_client)
            list_feed.elements.each('entry') do |entry| 
                puts "Enter grade for student #{}"
                score=STDIN.gets.chomp
                grade=Gradebook::Grade.new(@client.sps_client,@sps_id,column_id)
                grade.enter_grade(entry,score)
            end
        end
        
=begin rdoc
    Returns a grade report for a student by searching for their row in the spreadshet using their SID (student ID) as a parameter
=end
        def grade_report(sid)
            list_feed=Search.search_with_sid(sid,@sps_id,@client.sps_client)
            row=Hash.new
            list_feed.elements.each('entry') do |entry|
                entry.elements.each('gsx:*') do |col|
                    row[col.name]=col.text
                end
                row.each do |key,value|
                    if value.class==String
                        puts "#{key}:#{value}"
                    end
                end
                
            end
            
        end
        
    end
end
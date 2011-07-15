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
  #          puts "Enter search term for grade category"
 #           category=STDIN.gets.chomp
#            puts "Searching for category... #{category}"
   #         column_id=Gradebook::Search.search_for_column_id(category,@headers)
            column_id=self.create_or_search_for_category
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
            #puts "Enter search term for grade category"
            #category=STDIN.gets.chomp
            #puts "Searching for category... #{category}"
            #column_id=Gradebook::Search.search_for_column_id(category,@headers)
            column_id=self.create_or_search_for_category
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
        
=begin rdoc
    Returns a grade report for a student by searching for their row in the spreadsheet using their Name as a paramater. 
=end
        def grade_report_by_name(name)
            puts "Name #{name}"
            list_feed=Search.search_for_sid(name,@sps_id,@client.sps_client)
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
        
=begin rdoc
    This method runs while grading.  It prompts the user for the category (column name) that is to be graded.  If the category exists it is returned by searching. 
    If it does not exist 'new_category(category) is run which will create the new category and the search will be repeated by getting the new list of categories.
=end
        def create_or_search_for_category
            puts "Enter a category name, if it does not match a current category one will be created"
            category=STDIN.gets.chomp
            puts "Searching for category... #{category}"
            column_id=Gradebook::Search.search_for_column_id(category,@headers)
            if column_id.first.class!=String
                puts "Category does not exist and is being created."
                self.new_category(category)
                @headers=Search.get_columns_headers(@client.sps_client,@sps_id)
                column_id=Gradebook::Search.search_for_column_id(category,@headers)
            else
                puts "Category exists."
            end
            puts "Column id: #{column_id}, isa #{column_id.class} contains #{column_id.inspect}"
            return column_id
        end
        
=begin rdoc
    Add Average forumula to a column
=end
        def add_average
            
        end
             
=begin rdoc
    Add a new student to list feed
=end
        def add_student
            #list_feed=Utility.get_list_feed(@client.sps_client,@sps_id)
           #  list_feed.elements.each do |entry|
                # puts entry
          #   end
            entry=Utility.new_entry
            #entry.add_element 'gs:cell',{"row"=>"#{row_num}","col"=>"#{column_num}","inputValue"=>"=AVERAGE(R2C#{column_num}:R#{last_row}C#{column_num})"}            
            # entry.elements.each("gsx:*[#{@column_id}]") do |col|
            #     col.text=grade
            # end
#            entry.add_element "gsx:id"
            tag=Utility.sps_get_etag(@client.sps_client,@sps_id)
            @client.sps_client.headers['If-None-Match']=tag
    #            @sps_client.put(edit_uri,entry.to_s)
#                                                https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true
            #used_rows=Utility.get_number_of_used_rows(@client.sps_client,@sps_id)
                body=<<-EOF
<entry xmlns="http://www.w3.org/2005/Atom"
xmlns:gsx="http://schemas.google.com/spreadsheets/2006/extended">
</entry>
EOF
            puts body

            response=@client.sps_client.post("https://spreadsheets.google.com/feeds/list/#{@sps_id}/od6/private/full",entry.to_s)
            puts response.inspect
            
        end
        
=begin rdoc
    Wraps Utility functions to create a new category.
=end
        def new_category(category)
            sheet=Search.sps_get_sheet(@client.sps_client,@sps_id)
            rows=Search.sps_get_rows(@client.sps_client,@sps_id)
            Utility.add_category(@client.sps_client,@sps_id,category,rows,sheet)
        end

=begin rdoc
    Average a category(column)
=end
        def category_average
            puts "Enter a category name."
            category=STDIN.gets.chomp
            puts "Searching for category... #{category}"
            column_id=Gradebook::Search.search_for_column_id(category,@headers)
            Utility.category_average(@client.sps_client,@sps_id,column_id)
        end
    end
end
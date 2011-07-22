gem 'gdata2', '=1.0'
include Gradebook
=begin rdoc
    A class that encapsulates the grading classes
=end
module Gradebook
               class Array; def sum; inject( nil ) { |sum,x| sum ? sum+x : x }; end; end  
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
        
        def grade_all2
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
    Returns a grade report for a student by searching for their row in the spreadshet using their SID (student ID) as a parameter.
=end
        def grade_report(sid)
            list_feed=Search.search_with_sid(sid,@sps_id,@client.sps_client)
            row=Hash.new
            list_feed.elements.each('entry') do |entry|
                entry.elements.each('gsx:*') do |col|
                    row[col.name]=col.text
                end
                puts "\e[4;1;36mReport\e[0m"
                row.each do |key,value|
                    if value.class==String
                        puts "\e[4;1;36m#{key}\e[0m"+'::'+"\e[4;1;34m#{value}\e[0m"
                    end
                end  
            end
        end
        
=begin rdoc
    Returns an XML Grade report for a student by searching for their row in the spreadsheet using their SID (student ID) as a parameter.
    TODO Separate name to first name and last name.
=end
        def grade_report_xml(sid)
            list_feed=Search.search_with_sid(sid,@sps_id,@client.sps_client)
            xmlDoc=REXML::Document.new
            xmlDoc.add_element 'Grade Report' #root
            root=xmlDoc.root
            student=root.add_element('student', {'firstname'=>"#{list_feed.elements['entry/gsx:name'].text}",
                                            'lastname'=>"#{list_feed.elements['entry/gsx:name'].text}",
                                            'id'=>"#{list_feed.elements['entry/gsx:id'].text}"})
            list_feed.elements.each('entry') do |entry|
                entry.elements.each('gsx:*') do |col|
                    if col.name!='name' && col.name!='id'
                        category=student.add_element("#{col.name}")
                        category.text="#{col.text}"
                    end
                end
            end
            out=""
            xmlDoc.write(out, 1)

            puts out

                      
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
                        puts "\e[4;1;36m#{key}\e[0m"+'::'+"\e[4;1;34m#{value}\e[0m"
                    end
                end  
            end 
        end
        
=begin rdoc
     Returns an XML Grade report for a student by searching for their row in the spreadsheet using their name as a parameter.
    TODO Separate name to first name and last name.
=end
         def grade_report_by_name_xml(name)
            list_feed=Search.search_for_sid(name,@sps_id,@client.sps_client)
            xmlDoc=REXML::Document.new
            xmlDoc.add_element 'Grade Report' #root
            root=xmlDoc.root
            student=root.add_element('student', {'firstname'=>"#{list_feed.elements['entry/gsx:name'].text}",
                                            'lastname'=>"#{list_feed.elements['entry/gsx:name'].text}",
                                            'id'=>"#{list_feed.elements['entry/gsx:id'].text}"})
            list_feed.elements.each('entry') do |entry|
                entry.elements.each('gsx:*') do |col|
                    if col.name!='name' && col.name!='id'
                        category=student.add_element("#{col.name}")
                        category.text="#{col.text}"
                    end
                end
            end
            out=""
            xmlDoc.write(out, 1)
            puts out           
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
            return column_id
        end
        
=begin rdoc
    Add Average forumula to a column
=end
        def add_average
            
        end
             
=begin rdoc
    Add a new student to list feed
    ##Under Development  TODO
=end
        def add_student
            #list_feed=Utility.get_list_feed(@client.sps_client,@sps_id)
           #  list_feed.elements.each do |entry|
                # puts entry
          #   end
            entry=Utility.new_entry
            id=entry.add_element 'gsx:id'
            hw1=entry.add_element 'gsx:hw1'
            id.text="TestNew"
            hw1.text="94"
            puts entry
            #entry.add_element 'gs:cell',{"row"=>"#{row_num}","col"=>"#{column_num}","inputValue"=>"=AVERAGE(R2C#{column_num}:R#{last_row}C#{column_num})"}            
            # entry.elements.each("gsx:*[#{@column_id}]") do |col|
            #     col.text=grade
            # end
#            entry.add_element "gsx:id"
            #tag=Utility.sps_get_etag(@client.sps_client,@sps_id)
            #@client.sps_client.headers['If-None-Match']=tag
    #            @sps_client.put(edit_uri,entry.to_s)
#                                                https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true
            used_rows=Utility.get_number_of_used_rows(@client.sps_client,@sps_id)
            puts "used_rows #{used_rows}"


            response=@client.sps_client.post("https://spreadsheets.google.com/feeds/list/0AkCuQp9zaZcbdEZmM3Zjby1HTi1rLTY0Zm9kOUttc0E/od6/private/full",entry.to_s)
            puts response.inspect
            
        end
        
=begin rdoc
    Wraps Utility functions to create a new category.
=end
        def new_category(category)
#            sheet=Search.sps_get_sheet(@client.sps_client,@sps_id)
            sheet=Utility.sps_get_sheet(@client.sps_client,@sps_id)
            rows=Utility.get_list_feed(@client.sps_client,@sps_id,'',1)
#            rows=Search.sps_get_rows(@client.sps_client,@sps_id)
            Utility.add_category(@client.sps_client,@sps_id,category,rows,sheet)
        end

=begin rdoc
    Wraps Utility functions to remove a category.
=end
        def remove_category(category)
           response=Utility.remove_category(@client.sps_client,@sps_id,category) 
           if response==nil
               puts "\e[1;37mCategory does not exist.\e[0m"
           else
               puts "\e[1;34mCategory removed.\e[0m"
           end
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
        
=begin rdoc
    Extract category weight code.
=end
        def extract_category_weight_from_header

            weights=Utility.get_category_weights(@client.sps_client,@sps_id,2) 
            cells=Utility.get_cell_feed(@client.sps_client,@sps_id,params='&max-row=1')
            cells.elements.each('entry') do |entry|
                entry.elements.each('gs:cell') do |cell|
                     weight_code=cell.text.gsub!(/[-]\w*/,'') #removes column name and hyphen ie. HW-Homework1 becomes HW, Q-Quiz3 becomes Q
                     if weights.has_key?(weight_code)
                         puts "Value: #{weights[weight_code]}, Weight_code:#{weight_code}"
                     end
                end
            end                          
        end
        
=begin rdoc
    Averages a row (student) score for a particular category ie. HW
=end
        def category_average_for_each_studnet
            #puts "Enter a category"
           #category=STDIN.gets.chomp
           category="q"  #remove after testing, replace with above
           prefix=Utility.get_weight_code_for_category(category) 
           weights=Utility.get_category_weights(@client.sps_client,@sps_id,2)
           weight=weights.values_at(prefix)
           
           list_feed=Utility.get_list_feed(@client.sps_client,@sps_id,nil,1)

           list_feed.elements.each('entry') do |row|
               weighted_average=[]
               row.elements.each('gsx:*') do |ele|
                   code=Utility.get_weight_code_for_category(ele.name).to_s
                   if (code<=>prefix)==0
                       puts "Matched Element #{ele.name}"
                       pts_possible=Utility.get_possible_points_for_category(@client.sps_client,@sps_id,ele.name)  #get this once then have a hash
                       puts "pts#{pts_possible}"
                       weighted_average<<(ele.text.to_f/pts_possible.values_at(ele.name).first.to_f)*weight.first.to_f
                   end                       
               end
               puts "Weighted Average Size: #{weighted_average.size}"
               puts "Weighted Average: #{weighted_average.inspect}"
               puts "Weighted Average Sum:#{weighted_average.inject{|sum,x| sum + x }} "
               puts ""     
            end
        end
    end
end
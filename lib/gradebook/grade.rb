gem 'gdata2', '=1.0'

module Gradebook
   class Grade
       def initialize(sps_client,sps_id,column_id)
           @sps_client=sps_client
           @sps_id=sps_id
           @column_id=column_id
        end
     
#        def grade_each_student(list_feed)
#             list_feed.elements.each('entry') do |entry| 
#                 student_name=''
#                 entry.elements.each('gsx:name') do |name|
#                     student_name=name 
#                 end
#                 puts "Students Name: #{student_name.text}"
#                 puts "Enter Grade for #{student_name.text}:"
#                 self.enter_grade(entry)
#             end
#         end
   
        def enter_grade(entry,grade)
            edit_uri=''
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
        
=begin rdoc
    Batch Grade All
    TODO: Complete
=end
 def batch_grade_all(grade,category_name)
            headers=Search.get_columns_headers(@sps_client,@sps_id)
            column_id=Search.search_for_column_id(category_name,headers)
            name_column=Search.search_for_column_id(category_name,headers)
            
            cells=@sps_client.get("https://spreadsheets.google.com/feeds/cells/#{@sps_id}/1/private/full?prettyprint=true").to_xml
            batch_post_url=cells.elements['id'].text=cells.elements["link[@rel='http://schemas.google.com/g/2005#batch']"].attributes['href'] #converts ID element to the post batch rel
            new_cells_feed=REXML::Document.new
            root=new_cells_feed.add_element 'feed'
            root.add_namespace('http://www.w3.org/2005/Atom')
            root.add_namespace('batch','http://schemas.google.com/gdata/batch')
            root.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
                        
            cells.elements.each('entry') do |cell|
                if cell.elements['gs:cell'].attributes['col']==column_id.first  #column_id is an array so we remove the first element
                    entry=REXML::Element.new(arg='entry')
                    (entry.add_element 'batch:id').add_text(cell.elements['title'].text)
                    entry.add_element 'batch:operation', {"type"=>"update"}
                    (entry.add_element 'id').add_text(cell.elements['id'].text)
                    entry.add_element 'link', {"rel"=>"edit","type"=>"application/xml","href"=>"#{cell.elements['id'].text}"}
                    entry.add_element "gs:cell", {"row"=>"#{cell.elements['gs:cell'].attributes['row']}", "col"=>"#{cell.elements['gs:cell'].attributes['col']}", "inputValue"=>"#{grade}"}
                    root.add_element entry    
                end
            end
            tag=Utility.sps_get_etag(@sps_client,@sps_id)
            @sps_client.headers['If-None-Match']=tag
            @sps_client.post(batch_post_url,new_cells_feed)
        end
   end 
end
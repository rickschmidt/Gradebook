gem 'gdata2', '=1.0'

require 'gradebook/cache'
require 'gradebook/utility/base'

=begin rdoc
    A class for gathering basic stats 
=end
module Gradebook
module Utility
    class Structure < Gradebook::Utility::Base
        

=begin rdoc
    Adds  a category to the gradebook.  First the number of categories already present should be calculated using *get_number_of_used_columns*
=end
        def add_category(category_name)
			rows||=self.get_list_feed
			sheet||=self.sps_get_sheet
            used_col_count=self.get_number_of_used_columns
            total_col_count=self.get_number_of_columns
            
            if used_col_count >=total_col_count
                self.add_columns(1)
            end

            headers=self.get_columns_headers

            if headers.has_key?(category_name)
				puts "Category Exists"
                return "Category exists"

            end

  #              puts rows
#            entry=rows.root.elements['entry']
            # entry=self.new_entry
            # puts entry
             entry = rows.root.elements['entry'] # first <atom:entry>
#            entry=REXML::Element.new(arg='entry')
#           entry.add_namespace('http://www.w3.org/2005/Atom')
 #          entry.add_namespace('gd','http://schemas.google.com/g/2005')
  #         entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
   #        entry.add_namespace('gsx','http://schemas.google.com/spreadsheets/2006/extended')
 
            entry.add_namespace('http://www.w3.org/2005/Atom')
            entry.add_namespace('gd','http://schemas.google.com/g/2005')
          entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
            entry.add_namespace('gsx','http://schemas.google.com/spreadsheets/2006/extended')
#            rows.elements['gs:cell'].add_attributes({"row"=>"1","col"=>"#{used_col_count+1}","inputValue"=>"#{category_name}"})
#            el = doc.add_element 'my-tag', {'attr1'=>'val1', 'attr2'=>'val2'}
            entry.add_element 'gs:cell',{"row"=>"1","col"=>"#{used_col_count+1}","inputValue"=>"#{category_name}"}            
   #                    puts entry
            tag=self.get_etag_list_feed
          
            @client.sps_client.headers['If-None-Match']=tag
			url="https://spreadsheets.google.com/feeds/cells/#{@sps_id}/od6/private/full/R1C#{used_col_count+1}"
            response=@client.sps_client.put(url,entry)             
			Gradebook::Utility::Logger.log("#{Time.now}", "PUT","#{url}","Response:#{response.status_code}")
            return response
        end
        
   
=begin rdoc
    Adds another column to the spreadsheet by upating the sheets meta data. 
=end

    def add_columns(num_of_columns)
		sheet||=self.sps_get_sheet
        sheet=sheet.root.elements['entry[1]']
        
        col_count=0        
        col_count=sheet.root.elements['entry[1]/gs:colCount'].text.to_i
         # do |entry|
         #            col_count=entry.elements['gs:colCount'].text.to_i
         #        end
        
        total_columns=col_count+num_of_columns
    
#        entry=sheet.elements['entry'] # first <atom:entry>
        
        #entry.elements['gs:colCount'].text = "#{total_columns.to_i}"
        sheet.root.elements['entry[1]/gs:colCount'].text="#{total_columns.to_i}"
        edit_uri = sheet.root.elements["entry[1]/link[@rel='edit']"].attributes['href']

        tag=self.sps_get_etag_sheet(1)
#               tag=tag.gsub! /"/, ''
        
        sheet.add_namespace('http://www.w3.org/2005/Atom')
        sheet.add_namespace('gd','http://schemas.google.com/g/2005')
        sheet.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
   
        response=@client.sps_client.put("https://spreadsheets.google.com/feeds/worksheets/#{@sps_id}/private/full/od6",sheet.to_s)
             
         return response
    end
    
    
=begin rdoc
    Remove a given number of columns from the spreadsheet by upating the sheets meta data. 
    This method does not remove a specific column.  It removes columns from right to left.
=end
           def remove_columns(num_of_columns)
				sheet||=self.sps_get_sheet
                  sheet=sheet.root.elements['entry[1]']
          
          

                  
                 col_count=sheet.root.elements['entry[1]/gs:colCount'].text.to_i
                  # sheet.elements.each('entry') do |entry|
                  #                       col_count=entry.elements['gs:colCount'].text.to_i
                  #                   end
                  
                  total_columns=col_count-num_of_columns
                  
               sheet.root.elements['entry[1]/gs:colCount'].text="#{total_columns.to_i}"
        edit_uri = sheet.root.elements["entry[1]/link[@rel='edit']"].attributes['href']
        tag=self.sps_get_etag_sheet(1)
#               tag=tag.gsub! /"/, ''
        
        sheet.add_namespace('http://www.w3.org/2005/Atom')
        sheet.add_namespace('gd','http://schemas.google.com/g/2005')
        sheet.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
   
        response=@client.sps_client.put(edit_uri,sheet.to_s)
             
                   return response
              end

   

      


    
=begin rdoc
    Creates a new xml entry for the list feed and adds the equired namespaces
=end
        def self.new_entry
            entry=REXML::Element.new(arg='entry')
            entry.add_namespace('http://www.w3.org/2005/Atom')
            entry.add_namespace('gd','http://schemas.google.com/g/2005')
            entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
            entry.add_namespace('gsx','http://schemas.google.com/spreadsheets/2006/extended')
            return entry
        end
        
=begin rdoc
    Creates a new xml entry for the cell feed batch update
=end
        # def new_batch_entry
        #    entry=REXML::Element.new(arg='entry')
        #    entry.add_element( )
        # end   
       
           
           
  #          <entry>
  #   <batch:id>A1</batch:id>
  #   <batch:operation type="update"/>
  #   <id>https://spreadsheets.google.com/feeds/cells/key/worksheetId/private/full/R2C4</id>
  #   <link rel="edit" type="application/atom+xml"
  #     href="https://spreadsheets.google.com/feeds/cells/key/worksheetId/private/full/R2C4/version"/>
  #   <gs:cell row="2" col="4" inputValue="newData"/>
  # </entry>
        
=begin rdoc
    Removes a specific category from the spreadsheet.
    Uses a batch request to remove every entry in a column.
	TODO:  A bug was fixed where no elements were being added to teh cells feed. Namespaces were being added.
	This resulted in the posting of an empty feed which missed the testing since the response was still 200. 
	
=end
        def remove_category(category_name)
			@function=Gradebook::Utility::Function.new(@client)
			column_id=@function.search_for_column_id(category_name)
			begin
	            if column_id.first!=nil
	               params="&min-col=#{column_id}&max-col=#{column_id}"
	               url="https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true#{params}"
	                cells=self.get_cell_feed("#{column_id}","&min-col=#{column_id}&max-col=#{column_id}")                    
	                batch_post_url=cells.root.elements['id'].text=cells.root.elements["link[@rel='http://schemas.google.com/g/2005#batch']"].attributes['href'] #converts ID element to the post batch rel
	                new_cells_feed=REXML::Document.new
	                root=new_cells_feed.add_element 'feed'
	                root.add_namespace('http://www.w3.org/2005/Atom')
	                root.add_namespace('batch','http://schemas.google.com/gdata/batch')
	                root.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
                        
	                cells.root.elements.each('entry') do |cell|
	                    if cell.elements['gs:cell'].attributes['col']==column_id.first  #column_id is an array so we remove the first element
	                        entry=REXML::Element.new(arg='entry')
	                        (entry.add_element 'batch:id').add_text(cell.elements['title'].text)
	                        entry.add_element 'batch:operation', {"type"=>"update"}
	                        (entry.add_element 'id').add_text(cell.elements['id'].text)
	                        entry.add_element 'link', {"rel"=>"edit","type"=>"application/xml","href"=>"#{cell.elements['id'].text}"}
	                        entry.add_element "gs:cell", {"row"=>"#{cell.elements['gs:cell'].attributes['row']}", "col"=>"#{cell.elements['gs:cell'].attributes['col']}", "inputValue"=>""}
	                        root.add_element entry    
	                    end
	                end
                	if new_cells_feed.root.elements.size >0
		
	                	list_feed=self.get_list_feed(worksheet_id=1,params='')
		                tag=self.get_etag_list_feed
		                @client.sps_client.headers['If-None-Match']=tag
		                response=@client.sps_client.post(batch_post_url,new_cells_feed)
					return response
					else
						raise "Batch Cell Feed Empty"
					end
	            end
			raise "Search returned no results"
		end

            
        end
        
      


        

        

    end
end
end



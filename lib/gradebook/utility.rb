require 'gdata'
require 'gradebook/search'
=begin rdoc
    A class for gathering basic stats 
=end
module Gradebook
    class Utility
        

=begin rdoc
    Adds  a category to the gradebook.  First the number of categories already present should be calculated using *get_number_of_used_columns*
=end
        def self.add_category(sps_client,sps_id,category_name,rows,sheet)
            used_col_count=self.get_number_of_used_columns(rows)
            total_col_count=self.get_number_of_columns(sheet)
            if used_col_count >=total_col_count
                self.add_columns(1,sps_client,sheet,sps_id)
            end


            entry = rows.elements['entry'] # first <atom:entry>
            entry.add_namespace('http://www.w3.org/2005/Atom')
            entry.add_namespace('gd','http://schemas.google.com/g/2005')
            entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
            entry.add_namespace('gsx','http://schemas.google.com/spreadsheets/2006/extended')
 #           entry.elements['gs:cell'].add_attributes({"row"=>"1","col"=>"#{used_col_count+1}","inputValue"=>"#{category_name}"})
#            el = doc.add_element 'my-tag', {'attr1'=>'val1', 'attr2'=>'val2'}
            entry.add_element 'gs:cell',{"row"=>"1","col"=>"#{used_col_count+1}","inputValue"=>"#{category_name}"}            
            tag=self.sps_get_etag(sps_client,sps_id)
            sps_client.headers['If-None-Match']=tag
            response=sps_client.put("https://spreadsheets.google.com/feeds/cells/#{sps_id}/od6/private/full/R1C#{used_col_count+1}",entry)             
        end
        
        
=begin rdoc
    Adds another column to the spreadsheet by upating the sheets meta data. 
=end
    def self.add_columns(num_of_columns,sps_client,sheet,sps_id)



        col_count=0
        
        
        
        sheet.elements.each('entry') do |entry|
            col_count=entry.elements['gs:colCount'].text.to_i
        end
        
        total_columns=col_count+num_of_columns
        
        entry = sheet.elements['entry'] # first <atom:entry>
        
        entry.elements['gs:colCount'].text = "#{total_columns.to_i}"
        
        edit_uri = entry.elements["link[@rel='edit']"].attributes['href']
        tag=self.sps_get_etag(sps_client,sps_id)
#               tag=tag.gsub! /"/, ''
        
        entry.add_namespace('http://www.w3.org/2005/Atom')
        entry.add_namespace('gd','http://schemas.google.com/g/2005')
        entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
        
        response=sps_client.put("https://spreadsheets.google.com/feeds/worksheets/#{sps_id}/private/full/od6",entry.to_s)
             
         
    end
    
=begin rdoc
    Remove a given number of columns from the spreadsheet by upating the sheets meta data. 
    This method does not remove a specific column.  It removes columns from right to left.
=end
    def self.remove_columns(num_of_columns,sps_client,sheet,sps_id)



        col_count=0
        
        
        sheet.elements.each('entry') do |entry|
            col_count=entry.elements['gs:colCount'].text.to_i
        end
        
        total_columns=col_count-num_of_columns
        
        entry = sheet.elements['entry'] # first <atom:entry>
        
        entry.elements['gs:colCount'].text = "#{total_columns.to_i}"
        
        edit_uri = entry.elements["link[@rel='edit']"].attributes['href']
        tag=self.sps_get_etag(sps_client,sps_id)
#               tag=tag.gsub! /"/, ''
        
        entry.add_namespace('http://www.w3.org/2005/Atom')
        entry.add_namespace('gd','http://schemas.google.com/g/2005')
        entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
        
        response=sps_client.put("https://spreadsheets.google.com/feeds/worksheets/#{sps_id}/private/full/od6",entry.to_s)
     
         
    end
    
=begin rdoc
    Returns the number of rows in a given sheet.  Indexing starts at 1 because this atrribute is user focused.
=end
        def self.get_number_of_columns(sheet)
            colCount=0
            sheet.elements.each('entry') do |entry|
                colCount=entry.elements['gs:colCount'].text
            end 
           return colCount.to_i
        end
        
=begin rdoc
    Returns the number of columns in the first row that have are not blank from left to right.  Blank columns should not be used in the middle of the sheet.  
    The number of columns that are not blanked is needed to calculate where to put a new category.
=end
           
        def self.get_number_of_used_columns(rows)
            column_headers=[]
            rows.elements.each('entry[1]//gsx:*')  do |header| 
                column_headers<<header
            end
            
            return column_headers.size
        end
            
=begin rdoc
    Returns the number of rows in a given sheet.  Indexing starts at 1 because this atrribute is user focused.
=end
        def self.get_number_of_rows(sps_id,sheet)
           rowCount=0
           sheet.elements.each('entry') do |entry|
               rowCount=entry.elements['gs:rowCount'].text
           end 
           return rowCount.to_i
        end
        
=begin rdoc
    Returns the number of primary entry rows from the feed.  This should be representative of the number of students in the class
=end
        def self.get_number_of_used_rows(sps_client,sps_id)
            sps_feed=self.get_list_feed(sps_client,sps_id)
            rowCount=0
            sps_feed.elements.each('entry') do |entry|
                rowCount=rowCount+1
            end
            return rowCount
        end
        
=begin rdoc
    Returns the etag for authorization headers for the course that is searched for as a param.  Returns nil if no course is found.
=end
        def self.sps_get_etag(sps_client,id)
                etag=nil
                @sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/worksheets/#{id}/private/full").to_xml
                @sps_feed.elements.each('entry') do |entry|
                    etag=entry.attribute('etag').value
                end

            return etag
        end

=begin rdoc
    Returns the version of a worksheet extracted from its meta feed.
=end
        def self.sps_get_version(sps_client,id)
            version=nil
            sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/worksheets/#{id}/private/full?prettyprint=true").to_xml
            
            sps_feed.elements.each('entry') do |entry|
                version=entry.attribute('version')
            end

            return version
        end
        
=begin rdoc
  Return the list feed ie row by row entries.
  @params sps_client,
    sps_id,
    params:url params:defaults to blank ie '',
    worksheet_id defaults to 1
  
=end
      def self.get_list_feed(sps_client,sps_id,params='',worksheet_id=1)
        sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/list/#{sps_id}/#{worksheet_id}/private/full?prettyprint=true#{params}").to_xml
        return sps_feed
      end
      

=begin rdoc
    Average a category
=end
    def self.category_average(sps_client,sps_id,column_num)
        #sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true&range=R2C#{column_num}:R25C#{column_num}").to_xml
        # sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true&min-col=#{column_num}&max-col=#{column_num}&min-row=2").to_xml
        #         sps_feed.elements.each('entry') do |entry|
        #             entry.elements.each('gs:cell') do |cell|
        #                 puts cell.text
        #             end
        #         end
        stats_sheet=sps_client.get("https://spreadsheets.google.com/feeds/list/#{sps_id}/1/private/full?prettyprint=true").to_xml
        last_row=self.get_number_of_used_rows(sps_client,sps_id)+1
        row_num=last_row+2
        #entry=stats_sheet.elements['entry']
       # entry=REXML::Element.new(arg='entry')
        edit_uri=''
        entry=self.new_entry
        #entry.elements.each('link') do |link|
         #   edit_uri = entry.elements["link[@rel='edit']"].attributes['href']
        #end
#            entry.add_element 'gsx:hw1',{"inputValue"=>"=AVERAGE(R3C#{column_num}:R25C#{column_num})"}            
#                       puts "entry #{entry}"
        # entry.elements.each("gsx:hw1") do |col|
        #                 col.text="=AVERAGE(R3C#{column_num}:R25C#{column_num})"
        #             end
        entry.add_element 'gs:cell',{"row"=>"#{row_num}","col"=>"#{column_num}","inputValue"=>"=AVERAGE(R2C#{column_num}:R#{last_row}C#{column_num})"}            
        puts "entry inspect #{entry.inspect}"
        tag=self.sps_get_etag(sps_client,sps_id)
        sps_client.headers['If-None-Match']=tag
#            @sps_client.put(edit_uri,entry.to_s)
        response=sps_client.put("https://spreadsheets.google.com/feeds/cells/#{sps_id}/od6/private/full/R#{row_num}C#{3}",entry.to_s)
        puts response.inspect
 
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
        def self.new_batch_entry()
           entry=REXML::Element.new(arg='entry')
           entry.add_element( )
           
       
           
           
  #          <entry>
  #   <batch:id>A1</batch:id>
  #   <batch:operation type="update"/>
  #   <id>https://spreadsheets.google.com/feeds/cells/key/worksheetId/private/full/R2C4</id>
  #   <link rel="edit" type="application/atom+xml"
  #     href="https://spreadsheets.google.com/feeds/cells/key/worksheetId/private/full/R2C4/version"/>
  #   <gs:cell row="2" col="4" inputValue="newData"/>
  # </entry>
        end
=begin rdoc
    Removes a specific category from the spreadsheet.
    Uses a batch request to remove every entry in a column.
    TODO: Will need to change columns headers after refactoring in Search
=end
        def self.remove_category(sps_client,sps_id,category_name)
            headers=Search.get_columns_headers(sps_client,sps_id)
            column_id=Search.search_for_column_id(category_name,headers)
            before=Time.now
            if column_id.first!=nil
                cells=sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?min-col=#{column_id}&max-col=#{column_id}&prettyprint=true").to_xml
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
                        entry.add_element "gs:cell", {"row"=>"#{cell.elements['gs:cell'].attributes['row']}", "col"=>"#{cell.elements['gs:cell'].attributes['col']}", "inputValue"=>""}
                        root.add_element entry    
                    end
                end
                after=Time.now
                puts "Time: #{after-before}"
                tag=self.sps_get_etag(sps_client,sps_id)
                sps_client.headers['If-None-Match']=tag
                response=sps_client.post(batch_post_url,new_cells_feed)
            end
            return response
        end
        
      
=begin rdoc
    Number of rows according to cell feed
=end
        def self.num_of_rows_cell_feed(sps_client,sps_id)
            response=sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true").to_xml
            puts response
        end
        
=begin rdoc
    Get cell feed
=end
        def self.get_cell_feed(sps_client,sps_id,params='')
            sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true#{params}").to_xml
        end
        
=begin rdoc
    Get column weights
=end
        def self.get_category_weights(sps_client,sps_id,worksheetid)
            weights={}
            list_feed=self.get_list_feed(sps_client,sps_id,'&sq=weights%3E0',2)
            list_feed.elements.each('entry') do |w|
                weights["#{w.elements['title'].text}"]="#{w.elements['gsx:weights'].text}"
            end
            return weights
        end
=begin rdoc
    Get weiht code for category.  Example param=="HW-HW1", "HW" is returned.  Another example param=="Q-Q3", "Q" is returned
=end 
        def self.get_weight_code_for_category(category)
           return category.gsub(/[-]\w*/,'').downcase
        end
    end
end



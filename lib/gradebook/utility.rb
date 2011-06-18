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
        
    end
end



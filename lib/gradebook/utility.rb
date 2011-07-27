gem 'gdata2', '=1.0'

require 'gradebook/cache'
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
            puts "used: #{used_col_count}"
            puts "total #{total_col_count}"
            if used_col_count >=total_col_count
                self.add_columns(1,sps_client,sheet,sps_id)
            end

            headers=self.get_columns_headers(sps_client,sps_id)            

            if headers.has_key?(category_name)
                puts "category exists"
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
            tag=self.get_etag_list_feed(rows)
          
            sps_client.headers['If-None-Match']=tag
            response=sps_client.put("https://spreadsheets.google.com/feeds/cells/#{sps_id}/od6/private/full/R1C#{used_col_count+1}",entry)             
            return response
        end
        
   
=begin rdoc
    Adds another column to the spreadsheet by upating the sheets meta data. 
=end

    def self.add_columns(num_of_columns,sps_client,sheet,sps_id)
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
        tag=self.sps_get_etag_sheet(sps_client,sps_id,sheet,1)
#               tag=tag.gsub! /"/, ''
        
        sheet.add_namespace('http://www.w3.org/2005/Atom')
        sheet.add_namespace('gd','http://schemas.google.com/g/2005')
        sheet.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
   
        response=sps_client.put("https://spreadsheets.google.com/feeds/worksheets/#{sps_id}/private/full/od6",sheet.to_s)
             
         
    end
    
    
=begin rdoc
    Remove a given number of columns from the spreadsheet by upating the sheets meta data. 
    This method does not remove a specific column.  It removes columns from right to left.
=end
           def self.remove_columns(num_of_columns,sps_client,sheet,sps_id)
                  sheet=sheet.root.elements['entry[1]']
          
          

                  
                 col_count=sheet.root.elements['entry[1]/gs:colCount'].text.to_i
                  # sheet.elements.each('entry') do |entry|
                  #                       col_count=entry.elements['gs:colCount'].text.to_i
                  #                   end
                  
                  total_columns=col_count-num_of_columns
                  
               sheet.root.elements['entry[1]/gs:colCount'].text="#{total_columns.to_i}"
        edit_uri = sheet.root.elements["entry[1]/link[@rel='edit']"].attributes['href']
        tag=self.sps_get_etag_sheet(sps_client,sps_id,sheet,1)
#               tag=tag.gsub! /"/, ''
        
        sheet.add_namespace('http://www.w3.org/2005/Atom')
        sheet.add_namespace('gd','http://schemas.google.com/g/2005')
        sheet.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
   
        response=sps_client.put(edit_uri,sheet.to_s)
             
                   return response
              end

   
=begin rdoc
    Returns the number of rows in a given sheet.  Indexing starts at 1 because this atrribute is user focused.
=end
        def self.get_number_of_columns(sheet)
            colCount=sheet.root.elements['entry[1]/gs:colCount'].text
           return colCount.to_i
        end
        
=begin rdoc
    Returns the number of columns in the first row that have are not blank from left to right.  Blank columns should not be used in the middle of the sheet.  
    The number of columns that are not blanked is needed to calculate where to put a new category.
=end
           
        def self.get_number_of_used_columns(rows)
            column_headers=[]
            e=rows.root.elements['entry[1]']
            e.elements.each('gsx:*') do |ele|
                column_headers<<ele
            end
            # rows.elements.each('entry[1]//gsx:*')  do |header| 
            #     puts "get used header #{header}"
            #     column_headers<<header
            # end
            
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
            # rowCount=0
            # sps_feed.elements.each('entry') do |entry|
            #     rowCount=rowCount+1
            # end 
            rowCount=sps_feed.root.elements.size
            return rowCount
        end
        
=begin rdoc
    Returns the etag for authorization headers for the course that is searched for as a param.  Returns nil if no course is found.
=end
        def self.sps_get_etag_sheet(sps_client,id,sps_feed,sheet_id=1)
               etag=nil
#                sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/worksheets/#{id}/private/full?prettyprint=true").to_xml

#                etag=sps_feed.root.attributes['gd:etag'].to_s
#                etag=sps_feed.elements[1,'entry'].attributes['gd:etag'].to_s
                # do |entry|
                #                     etag=entry.attribute('etag').value
                #                 end
#                sheet.root.elements['entry[1]/gs:colCount'].text="#{total_columns.to_i}"

                etag=sps_feed.root.elements["entry[#{sheet_id}]"].attributes['gd:etag'].to_s


            return etag
          end

=begin rdoc
    Etag
=end
        def self.get_etag_list_feed(list_feed)
            etag=list_feed.attributes['gd:etag'].to_s
            return etag
        end
        
=begin rdoc
    Returns the version of a worksheet extracted from its meta feed.
=end
        # def self.sps_get_version(sps_client,id)
        #     version=nil
        #     sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/worksheets/#{id}/private/full?prettyprint=true").to_xml
        #     
        #     sps_feed.elements.each('entry') do |entry|
        #         version=entry.attribute('version')
        #     end
        # 
        #     return version
        # end
        
=begin rdoc
  Return the list feed ie row by row entries.
  @params sps_client,
    sps_id,
    params:url params:defaults to blank ie '',
    worksheet_id defaults to 1
  
=end
      def self.get_list_feed(sps_client,sps_id,params='',worksheet_id=1)
          
          sps_feed=Gradebook::Cache.cache_get_request(sps_client,"list_feed_sheet_#{worksheet_id}","https://spreadsheets.google.com/feeds/list/#{sps_id}/#{worksheet_id}/private/full?prettyprint=true#{params}")
          
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
#        stats_sheet=sps_client.get("https://spreadsheets.google.com/feeds/list/#{sps_id}/1/private/full?prettyprint=true").to_xml
        stats_sheet=self.get_list_feed(sps_client,sps_id,'',1)
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
        
        tag=self.get_etag_list_feed(stats_sheet)
        sps_client.headers['If-None-Match']=tag
#            @sps_client.put(edit_uri,entry.to_s)
        response=sps_client.put("https://spreadsheets.google.com/feeds/cells/#{sps_id}/od6/private/full/R#{row_num}C#{3}",entry.to_s)
        
 
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
        def self.new_batch_entry
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
            headers=self.get_columns_headers(sps_client,sps_id)
           puts "in remove headers : #{headers.inspect}"
            column_id=self.search_for_column_id(category_name,headers)
  #      column_id=36
            puts "in remove cat col id :#{column_id}"
            before=Time.now
 #           if column_id==36 
            if column_id.first!=nil
#                cells=self.get_cell_feed(sps_client,sps_id,"&min-col=#{column_id}&max-col=#{column_id}")
=begin
    TODO Should cache from cells feed with params
=end
        
                    params="&min-col=#{column_id}&max-col=#{column_id}"
                        url="https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true#{params}"
                   
                   
                 y=sps_client.get(url)
            puts "y is #{y.inspect}"

#            puts "Equal?: #{@client.sps_client===sps_client}"
                cells=self.get_cell_feed(sps_client,sps_id,"#{column_id}","&min-col=#{column_id}&max-col=#{column_id}")                    
#                cells=sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?min-col=#{column_id}&max-col=#{column_id}&prettyprint=true").to_xml                
                puts "cells in remove cat : #{cells}"
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
                
                list_feed=self.get_list_feed(sps_client,sps_id,params='',worksheet_id=1)
                tag=self.get_etag_list_feed(list_feed)
                sps_client.headers['If-None-Match']=tag
                response=sps_client.post(batch_post_url,new_cells_feed)
            end
            puts "response #{response}"
            return response
        end
        
      
=begin rdoc
    Number of rows according to cell feed
=end
        def self.num_of_rows_cell_feed(sps_client,sps_id)
#            response=sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true").to_xml
            response=Gradebook::Cache.cache_get_request(sps_client,'rows')
            
        end
        
=begin rdoc
    Get cell feed
=end
        def self.get_cell_feed(sps_client,sps_id,col_range='all',params='')
            url="https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true#{params}"
            puts "url in get cell feed #{url}"
            x=sps_client.get(url)
            puts "x is #{x.inspect}"
            cell_feed=Gradebook::Cache.cache_get_request(sps_client,"cell_feed_#{col_range}",url)
            puts "cell_feed #{cell_feed}"
            return cell_feed
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
    Get weight code for category.  Example param=="HW-HW1", "HW" is returned.  Another example param=="Q-Q3", "Q" is returned
=end 
        def self.get_weight_code_for_category(category)
           return category.gsub(/[-]\w*/,'').downcase
        end
        
=begin rdoc
    Get points possible for a category.
=end
        def self.get_possible_points_for_category(sps_client,sps_id,category)
            pts_possible={}
            list_feed=self.get_list_feed(sps_client,sps_id,'&sq=pointspossible%3E0',2)
            list_feed.elements.each('entry') do |p|
                if (p.elements['title'].text<=>category)==0
                    pts_possible["#{p.elements['title'].text}"]="#{p.elements['gsx:pointspossible'].text}"
                end
            end
            return pts_possible
        end
        
=begin rdoc
    Returns the spreadsheet that is located by its id.
=end
        def self.sps_get_sheet(sps_client,sps_id)
            sps_feed=Gradebook::Cache.cache_get_request(sps_client,"sheet_feed_1","https://spreadsheets.google.com/feeds/worksheets/#{sps_id}/private/full?prettyprint=true")
            return sps_feed
        end
        
        
        
        # =begin rdoc
#     Returns the spreadsheet that is located by its id.
# =end
#         def self.sps_get_sheet(sps_client,sps_id)
#             sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/worksheets/#{sps_id}/private/full?prettyprint=true").to_xml
# 
#             return sps_feed
#         end

=begin rdoc
    Extracts the ID of a document entry and returns it. The entry would come from iterating through a feed.
=end
        def self.extract_document_id_from_feed(feed,entry)
            links={}
            entry.elements.each('link') do |link|
                links[link.attribute('rel').value] = link.attribute('href').value
            end

            if feed=="documents"
                id=entry.elements['id'].text[/.com\/feeds\/documents\/private\/full\/spreadsheet%3A(.*)/, 1]
            elsif feed=="spreadsheets"
                id=entry.elements['id'].text[/.com\/feeds\/spreadsheets\/(.*)/, 1]
            else
                
                id=nil
            end
            
            return id
        end
        
=begin rdoc
    Returns the spreadsheet id for the course that is searched for as a param.  Returns nil if no course is found.
=end
        def self.sps_get_course(doc_client,course)
                        
            @sps_feed=Gradebook::Cache.cache_get_request(doc_client,"doc_feed","https://documents.google.com/feeds/documents/private/full?q=#{course}&prettyprint=true")
            
#            @sps_feed=doc_client.get("https://documents.google.com/feeds/documents/private/full?q=#{course}&prettyprint=true").to_xml
            #  @sps_feed.elements.each do |e|
            #     e.elements.each do |f|
            #         puts f
            #     end
            # end
            if @sps_feed.elements['openSearch:totalResults'].text!="0"
                @sps_feed.elements.each('entry') do |entry|
                    if entry.elements['title'].text!=""
                        @sps_id=self.extract_document_id_from_feed("documents",entry)
                    end
                end
            else
                #puts "No Spreadsheet found with that course name"
                @sps_id=nil
            end

            return @sps_id
        end


      

=begin rdoc
    Returns the rows located by its ID as a list feed.
=end        

        # def self.sps_get_rows(sps_client,sps_id)
        #           rows=sps_client.get("https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true").to_xml
        #                       
        #           return rows
        #       end
        
=begin rdoc
    Returns the first row of a spreadsheet ie its column headers
    TODO: rows should be refactored to cells
    TODO: rename to columN (singular) 
=end

        def self.get_columns_headers(sps_client,sps_id)
            sps=sps_client.dup
            puts "equal headers? #{sps===sps_client}"
            rows=Gradebook::Cache.cache_get_request(sps,"cell_headers2","https://spreadsheets.google.com/feeds/cells/#{sps_id}/od6/private/full?prettyprint=true&max-row=1")
#         rows=get_list_feed(sps_client,sps_id)
           header_row=Hash.new
           rows.root.elements.each('entry')do |entry|
               entry.elements.each('gs:cell') do |header|
                   header_row[header.attribute('inputValue').value]=header.attribute('col').value
               end
           end

           
           return header_row
        end
        
=begin rdoc
    Search for a student by name and returns an id number to be used in other commands
=end
        def self.search_for_sid(search,sps_id,sps_client)
#            sps_id=self.sps_get_course("Roster")
            rows=Gradebook::Cache.cache_get_request(sps_client,"sid_search","https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true&sq=name=#{search}")

            row=Hash.new
            rows.elements.each('//gsx:id') do |header|
#            rows.elements.each do |header|
                row[header.name]=header.text
            end

            #puts "Searching for Student ID...#{search}"
            #puts "ID for #{row['name']}"
            row.each do |key,value|
                #puts "#{key} :#{value} "
            end
            return rows
        end
        
=begin rdoc
    Search for and return a SID fora student given their name
=end
        def self.search_for_and_return_sid(search,sps_id,sps_client)
            rows=Gradebook::Cache.cache_get_request(sps_client,"sid_search","https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true&sq=name=#{search}")
            row=Hash.new
            rows.elements.each('//gsx:id') do |header|
                row[header.name]=header.text
            end
            return row
        end
        
=begin rdoc
    Search for a student by id and returns the grades for that student
=end
        def self.search_with_sid(search,sps_id,sps_client)
            #puts "Searching for Student ID...#{search}"
            rows=Gradebook::Cache.cache_get_request(sps_client,"name_search","https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true&sq=id=#{search}")
            row=Hash.new
            rows.elements.each('//gsx:*') do |header|
                row[header.name]=header.text
            end
            # row.each do |key,value|
            #                 if value.class==String
            #                     puts "#{key} :#{value}"
            #                 end
            #             end

           # f "Student ID #{row['id']}"
            
            return rows
        end
        
=begin rdoc
  Search for a column id based on a search phrase and a header row
=end
      def self.search_for_column_id(search,headers)
        column_id=headers.values_at(search)
        return column_id
      end


    end
end



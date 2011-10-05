
=begin rdoc
	Author::Rick Schmidt
	The Base utility class is the base of core functionality of the application.  For the sake of smaller classes functionality was divided between Function and Structure 
	which both extend Base.  It goes without explanation that Structure provides functionality for altering the structure of the gradebook (adding and removing columns, categories etc).
	Function performs calculations on the data including searching.  Base (and subsequently all of its descendants) requires an authenticated client object during initialization.
	 
=end
module Gradebook
    module Utility
        class Base
        	attr_reader :sps_id
           	attr_reader :client
        
            def initialize(client)
             	@client=client
				@sps_id=client.sps_id
            end
            
=begin rdoc
	make_request would be ideal if this is to be redesigned.
=end
			def make_request(client_type,request_type,url,entry=nil)
				case client_type
				when :doc_client
					client=@client.doc_client
				when :sps_client
					client=@client.sps_client
				end
				
				case request_type
				when :get
					return client.get(url)
				when :put
					return client.put(url,enrty.to_s)
				when :post
					return client.post(url,entry.to_s)
				when :delete
					return client.delete(url)
				else
		          	raise ArgumentError, "Unsupported HTTP method specified."
		        end	
			end
		
        
=begin rdoc
    Returns the number of rows in a given sheet.  Indexing starts at 1 because this atrribute is user focused.
=end
            def get_number_of_columns
                sheet ||=self.sps_get_sheet
                colCount=sheet.root.elements['entry[1]/gs:colCount'].text
               	return colCount.to_i
            end

=begin rdoc
        Returns the number of columns in the first row that have are not blank from left to right.  Blank columns should not be used in the middle of the sheet.  
        The number of columns that are not blanked is needed to calculate where to put a new category.
=end           
            def get_number_of_used_columns
                rows ||=self.get_list_feed
                column_headers=[]				
                e=rows.root.elements['entry[1]']
                e.elements.each('gsx:*') do |ele|
                    column_headers<<ele
                end            
                return column_headers.size
            end
        
=begin rdoc
    Returns the number of rows in a given sheet.  Indexing starts at 1 because this atrribute is user focused.
=end
            def get_number_of_rows
                sheet ||=self.sps_get_sheet
               	rowCount=0
               	sheet.elements.each('entry') do |entry|
                   	rowCount=entry.elements['gs:rowCount'].text
               	end 
               	return rowCount.to_i
            end
        
=begin rdoc
    Returns the number of primary entry rows from the feed.  This should be representative of the number of students in the class
=end
            def get_number_of_used_rows
                sps_feed||=self.get_list_feed
                rowCount=sps_feed.elements.size
                return rowCount
            end
        
=begin rdoc
    Returns the etag for authorization headers for the course that is searched for as a param.  Returns nil if no course is found.
=end
            def sps_get_etag_sheet(sheet_id=1)
                sps_feed||=self.get_list_feed
                etag=nil
                etag=sps_feed.root.elements["entry[#{sheet_id}]"].attributes['gd:etag'].to_s
                return etag
              end

=begin rdoc
    Gets the etag for a list feed. 
=end
            def get_etag_list_feed
                list_feed||=self.get_list_feed
                etag=list_feed.attributes['gd:etag'].to_s
                return etag
            end
        
=begin rdoc
      Return the list feed ie row by row entries. Worksheet id defaults to one, params defaults to none.
  
=end
          def get_list_feed(worksheet_id='1',params='')
          	url="https://spreadsheets.google.com/feeds/list/#{@sps_id}/#{worksheet_id}/private/full?prettyprint=true#{params}"
		    cache=Gradebook::Cache.new
			list_feed=cache.cache_get_request(@client.sps_client,"list_feed_sheet#{worksheet_id}",url)
            return list_feed
          end
        
=begin rdoc
        Get cell feed
=end
            def get_cell_feed(col_range='all',params='')
                url="https://spreadsheets.google.com/feeds/cells/#{@sps_id}/1/private/full?prettyprint=true#{params}"
                cache=Gradebook::Cache.new        
                cell_feed=cache.cache_get_request(@client.sps_client,"cell_feed_#{params}",url)
                return cell_feed
            end
                
=begin rdoc
        Get points possible for a category.
=end
            def get_possible_points_for_category(category)
                pts_possible={}
				pts=nil
				list_feed||=self.get_list_feed("2","")#'&sq=pointspossible%3E0')
                list_feed.root.elements.each('entry') do |p|
                	if (p.elements['title'].text<=>category)==0
						pts="#{p.elements['gsx:pointspossible'].text}"
                    end
                end
				return pts.to_i
            end
     
=begin rdoc
        Returns the first row of a spreadsheet ie its column headers
=end
            def get_columns_headers
				cache=Gradebook::Cache.new        
                rows=cache.cache_get_request(@client.sps_client,"cell_headers2","https://spreadsheets.google.com/feeds/cells/#{@sps_id}/od6/private/full?prettyprint=true&max-row=1")
                header_row=Hash.new
                rows.root.elements.each('entry')do |entry|
                    entry.elements.each('gs:cell') do |header|
                       header_row[header.attribute('inputValue').value]=header.attribute('col').value
                    end
               end           
               return header_row
            end
        
=begin rdoc
    Returns the spreadsheet that is located by its id.
=end
        	def sps_get_sheet
		     	cache=Gradebook::Cache.new        
	            sps_feed=cache.cache_get_request(@client.sps_client,"sheet_feed_1","https://spreadsheets.google.com/feeds/worksheets/#{@sps_id}/private/full?prettyprint=true")
	            return sps_feed
	        end        
	
=begin rdoc
	Returns the name of the current spreadsheet. Ie the sps id in .gb/sps_id
=end
			def get_name_for_current_spreadsheet
				sheet_feed=self.sps_get_sheet
				name=sheet_feed.root.elements['title'].text
				return name
			end
        end
    end
end
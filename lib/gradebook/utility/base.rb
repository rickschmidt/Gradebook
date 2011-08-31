

require 'gradebook/cache'
=begin rdoc
    A class for gathering basic stats 
=end
module Gradebook
    module Utility
        class Base
        
        
           attr_reader :sps_id
           attr_reader :client
        
            def initialize(client)
  #              @client= Client.new
 #               @client.setup('','')
#                @sps_id=self.class.sps_get_course(@client.doc_client,"Roster")
             	@client=client
				@sps_id=client.sps_id
            end
            
			#currently not used, this would be ideal
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
                # rows.elements.each('entry[1]//gsx:*')  do |header| 
                #     puts "get used header #{header}"
                #     column_headers<<header
                # end
            
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
                # rowCount=0
                # sps_feed.elements.each('entry') do |entry|
                #     rowCount=rowCount+1
                # end 
                rowCount=sps_feed.elements.size
                return rowCount
            end
        
=begin rdoc
    Returns the etag for authorization headers for the course that is searched for as a param.  Returns nil if no course is found.
=end
            def sps_get_etag_sheet(sheet_id=1)
                    sps_feed||=self.get_list_feed
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
            def get_etag_list_feed
                list_feed||=self.get_list_feed
                etag=list_feed.attributes['gd:etag'].to_s
                return etag
            end
        
=begin rdoc
      Return the list feed ie row by row entries.
      @params sps_client,
        sps_id,
        params:url params:defaults to blank ie '',
        worksheet_id defaults to 1
  
=end
          def get_list_feed(worksheet_id='1',params='')
          		url="https://spreadsheets.google.com/feeds/list/#{@sps_id}/#{worksheet_id}/private/full?prettyprint=true#{params}"
				

		              cache=Gradebook::Cache.new
					list_feed=cache.cache_get_request(@client.sps_client,"list_feed_sheet#{worksheet_id}",url)
#          		list_feed=@client.sps_client.get(url).to_xml
			

             return list_feed
          end
     
# =begin rdoc
#         Number of rows according to cell feed
# =end
#             def num_of_rows_cell_feed
# 
#                 response=Gradebook::Cache.cache_get_request(@client.sps_client,'rows')
#             
#             end
        
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
                        #pts_possible["#{p.elements['title'].text}"]="#{p.elements['gsx:pointspossible'].text}"
						pts="#{p.elements['gsx:pointspossible'].text}"
                    end
                end
                #return pts_possible
				return pts.to_i
            end
        


=begin rdoc
        Returns the first row of a spreadsheet ie its column headers
        TODO: rows should be refactored to cells
        TODO: rename to columN (singular) 
=end

            def get_columns_headers

				cache=Gradebook::Cache.new        
                rows=cache.cache_get_request(@client.sps_client,"cell_headers2","https://spreadsheets.google.com/feeds/cells/#{@sps_id}/od6/private/full?prettyprint=true&max-row=1")
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
    Returns the spreadsheet that is located by its id.
=end
        def sps_get_sheet
		     cache=Gradebook::Cache.new        
            sps_feed=cache.cache_get_request(@client.sps_client,"sheet_feed_1","https://spreadsheets.google.com/feeds/worksheets/#{@sps_id}/private/full?prettyprint=true")
            return sps_feed
        end
        
        end
    end
end
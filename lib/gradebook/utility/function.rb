gem 'gdata2', '=1.0'

require 'gradebook/cache'
require 'gradebook/utility/base'

=begin rdoc
    A class for gathering basic stats 
=end
module Gradebook
	module Utility
    	class Function < Gradebook::Utility::Base
	
=begin rdoc
    Get weight code for category.  Example param=="HW-HW1", "HW" is returned.  Another example param=="Q-Q3", "Q" is returned
=end 
        	def get_weight_code_for_category(category)
	           return category.gsub(/[-]\w*/,'').downcase
	        end
	
=begin rdoc
    Average a category

=end
=begin
		TODO Complete, remove hard coding
=end
   		 def category_average(column_num)
		        #sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true&range=R2C#{column_num}:R25C#{column_num}").to_xml
		        # sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/1/private/full?prettyprint=true&min-col=#{column_num}&max-col=#{column_num}&min-row=2").to_xml
		        #         sps_feed.elements.each('entry') do |entry|
		        #             entry.elements.each('gs:cell') do |cell|
		        #                 puts cell.text
		        #             end
		        #         end
		#        stats_sheet=sps_client.get("https://spreadsheets.google.com/feeds/list/#{sps_id}/1/private/full?prettyprint=true").to_xml
		        stats_sheet||=self.get_list_feed(1,'')
		        last_row=self.get_number_of_used_rows+1
		        row_num=last_row+2
		        #entry=stats_sheet.elements['entry']
		       # entry=REXML::Element.new(arg='entry')
		        edit_uri=''
		        entry=Utility::Structure.new_entry
		        #entry.elements.each('link') do |link|
		         #   edit_uri = entry.elements["link[@rel='edit']"].attributes['href']
		        #end
		#            entry.add_element 'gsx:hw1',{"inputValue"=>"=AVERAGE(R3C#{column_num}:R25C#{column_num})"}            
		#                       puts "entry #{entry}"
		        # entry.elements.each("gsx:hw1") do |col|
		        #                 col.text="=AVERAGE(R3C#{column_num}:R25C#{column_num})"
		        #             end
		        entry.add_element 'gs:cell',{"row"=>"#{row_num}","col"=>"#{column_num}","inputValue"=>"=AVERAGE(R2C#{column_num}:R#{last_row}C#{column_num})"}            
        
		        tag=self.get_etag_list_feed
		        @client.sps_client.headers['If-None-Match']=tag
		        response=@client.sps_client.put("https://spreadsheets.google.com/feeds/cells/#{sps_id}/od6/private/full/R#{row_num}C#{3}",entry.to_s)
		        return response
 
		    end

=begin rdoc
    Search for a student by name and returns an id number to be used in other commands
=end
        def search_for_sid(search)
#            sps_id=self.sps_get_course("Roster")
			cache=Gradebook::Cache.new
            rows=cache.cache_get_request(@client.sps_client,"sid_search","https://spreadsheets.google.com/feeds/list/#{@sps_id}/od6/private/full?prettyprint=true&sq=name=#{search}")

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
    Search for and return a SID for a student given their name
=end
        def search_for_and_return_sid(search)
			cache=Gradebook::Cache.new
            rows=cache.cache_get_request(@client.sps_client,"sid_search","https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true&sq=name=#{search}")
            row=Hash.new
            rows.elements.each('//gsx:id') do |header|
                row[header.name]=header.text
            end
            return row
        end
        
=begin rdoc
    Search for a student by id and returns the grades for that student
=end
        def search_with_sid(search)
			cache=Gradebook::Cache.new
            rows=cache.cache_get_request(@client.sps_client,"name_search","https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true&sq=id=#{search}")
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
      def search_for_column_id(search)
		headers=self.get_columns_headers
        column_id=headers.values_at(search)
        return column_id
      end

=begin rdoc
    Get column weights
=end
        def get_category_weights(worksheetid)
            weights={}
            list_feed=self.get_list_feed(2,'&sq=weights%3E0')
            list_feed.elements.each('entry') do |w|
                weights["#{w.elements['title'].text}"]="#{w.elements['gsx:weights'].text}"
            end
            return weights
        end

=begin rdoc
    Get points possible for a category.
=end
        def get_possible_points_for_category(category)
            pts_possible={}
            list_feed=self.get_list_feed(2,'&sq=pointspossible%3E0')
            list_feed.elements.each('entry') do |p|
                if (p.elements['title'].text<=>category)==0
                    pts_possible["#{p.elements['title'].text}"]="#{p.elements['gsx:pointspossible'].text}"
                end
            end
            return pts_possible
        end

		end
	end
end
	
	
        
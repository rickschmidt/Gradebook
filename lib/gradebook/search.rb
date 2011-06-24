require 'gdata'

=begin rdoc
    A class for gathering basic stats 
=end
module Gradebook
    class Search
        
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
                puts "Invalid Feed: Must be 'documents' or 'spreadsheets'."
                id=nil
            end
            
            return id
        end
        
=begin rdoc
    Returns the spreadsheet id for the course that is searched for as a param.  Returns nil if no course is found.
=end
        def self.sps_get_course(doc_client,course)
            @sps_feed=doc_client.get("https://documents.google.com/feeds/documents/private/full?q=#{course}&prettyprint=true").to_xml
            if @sps_feed.elements['openSearch:totalResults'].text!="0"
                @sps_feed.elements.each('entry') do |entry|
                    if entry.elements['title'].text!=""
                        @sps_id=self.extract_document_id_from_feed("documents",entry)
                    end
                end
            else
                puts "No Spreadsheet found with that course name"
                @sps_id=nil
            end

            return @sps_id
        end
        
=begin rdoc
    Extracts the ID of a document entry and returns it. The entry would come from iterating through a feed.
=end
        def extract_document_id_from_feed(feed,entry)
            links={}
            entry.elements.each('link') do |link|
                links[link.attribute('rel').value] = link.attribute('href').value
            end

            if feed=="documents"
                id=entry.elements['id'].text[/.com\/feeds\/documents\/private\/full\/spreadsheet%3A(.*)/, 1]
            elsif feed=="spreadsheets"
                id=entry.elements['id'].text[/.com\/feeds\/spreadsheets\/(.*)/, 1]
            else
                puts "Invalid Feed: Must be 'documents' or 'spreadsheets'."
                id=nil
            end
            
            return id
        end
        
=begin rdoc
    Returns the spreadsheet that is located by its id.
=end
        def self.sps_get_sheet(sps_client,sps_id)
            sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/worksheets/#{sps_id}/private/full?prettyprint=true").to_xml

            return sps_feed
        end

=begin rdoc
    Returns the rows located by its ID as a list feed.
=end        

        def self.sps_get_rows(sps_client,sps_id)
            rows=sps_client.get("https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true").to_xml
                        
            return rows
        end
        
=begin rdoc
    Returns the first row of a spreadsheet ie its column headers
=end

        def self.get_columns_headers(sps_client,sps_id)
           rows=sps_client.get("https://spreadsheets.google.com/feeds/cells/#{sps_id}/od6/private/full?prettyprint=true&max-row=1").to_xml
           header_row=Hash.new
           rows.elements.each('entry')do |entry|
               entry.elements.each('gs:cell') do |header|
                   header_row[header.attribute('inputValue').value]=header.attribute('col').value
               end
           end

           
           return header_row
        end
        
=begin rdoc
    Search for a student by name and returns an id number to be used in other commands
=end
        def self.search_for_sid(search)
            sps_id=self.sps_get_course("Roster")
            rows=@sps_client.get("https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true&sq=id=#{search}").to_xml
            row=Hash.new
            rows.elements.each('//gsx:*') do |header|

                row[header.name]=header.text
            end
            puts row.inspect
            puts "Searching for Student ID...#{search}"
            puts "Grades for #{row['name']}"
            row.each do |key,value|
                puts "#{key} :#{value} "
            end
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
require 'rubygems'
gem 'gdata2'
require 'gdata'

module Gradebook
    class Client
    
       attr_accessor :doc_client
       attr_accessor :sps_client
       attr_accessor :doc_feed
       attr_accessor :sps_feed
       
       
        def initialize
           
        end
    
        
        def setup(username,password)
            #The DOC API must be used for creating new docs AND spreadsheets
            @doc_client = GData::Client::DocList.new
            @doc_client.clientlogin("gradebookluc","gradebookluc2011")
            
            #The Spreadsheets Client is used for everything except creation.
            @sps_client=GData::Client::Spreadsheets.new
            @sps_client.clientlogin("gradebookluc","gradebookluc2011")
#            puts "Token #{@sps_client.auth_handler.token}"
   
            return @doc_client, @sps_client
        
        end 
        
        
=begin rdoc
    Returns the document id for the course that is searched for as a param.  Returns nil if no course is found.
=end
        def get_course(course)
            @doc_feed=@doc_client.get("https://documents.google.com/feeds/documents/private/full?q=#{course}&prettyprint=true").to_xml

            if @doc_feed.elements['openSearch:totalResults'].text!="0"
                @doc_feed.elements.each('entry') do |entry|
                    if entry.elements['title'].text!=""
                        puts 'Title Match:' + entry.elements['title'].text
                        doc_id=extract_document_id_from_feed("documents",entry)
                        puts "ID for Match: " + doc_id.to_s
                    end
                end
            else
                puts "No Document found with that course name"
                doc_id=nil
            end

            return doc_id
        end
=begin rdoc
    Returns the number of rows in a given sheet.  Indexing starts at 1 because this atrribute is user focused.
=end
        def get_colCount 
            colCount=0
            sps_id=self.sps_get_course("Roster")
            sheet=self.sps_get_sheet(sps_id)
            sheet.elements.each('entry') do |entry|
                colCount=entry.elements['gs:colCount'].text
            end 
           return colCount.to_i
        end
=begin rdoc
    Returns the number of rows in a given sheet.  Indexing starts at 1 because this atrribute is user focused.
=end
        def get_rowCount
           rowCount=0
           sps_id=self.sps_get_course("Roster")
           sheet=self.sps_get_sheet(sps_id)
           sheet.elements.each('entry') do |entry|
               rowCount=entry.elements['gs:rowCount'].text
           end 
           return rowCount.to_i
        end
=begin rdoc
    Returns the spreadsheet id for the course that is searched for as a param.  Returns nil if no course is found.
=end
        def sps_get_course(course)
            @sps_feed=@doc_client.get("https://documents.google.com/feeds/documents/private/full?q=#{course}&prettyprint=true").to_xml
#            @sps_feed=@sps_client.get("https://spreadsheets.google.com/feeds/documents/private/full?q=#{course}&prettyprint=true").to_xml
            if @sps_feed.elements['openSearch:totalResults'].text!="0"
                @sps_feed.elements.each('entry') do |entry|
                    if entry.elements['title'].text!=""
                        puts 'Title Match:' + entry.elements['title'].text
                        @sps_id=extract_document_id_from_feed("documents",entry)
                        puts "ID for Match: " + @sps_id.to_s
                    end
                end
            else
                puts "No Spreadsheet found with that course name"
                @sps_id=nil
            end

            return @sps_id
        end
        
=begin rdoc
    Returns the spreadsheet that is located by its id.
=end
        def sps_get_sheet(id)
            @sps_feed=@sps_client.get("https://spreadsheets.google.com/feeds/worksheets/#{id}/private/full?prettyprint=true").to_xml


            return @sps_feed
        end
=begin rdoc
    Returns the etag for authorization headers for the course that is searched for as a param.  Returns nil if no course is found.
=end
        def sps_get_etag(course,id)
                etag=nil
                @sps_feed=@sps_client.get("https://spreadsheets.google.com/feeds/worksheets/#{id}/private/full").to_xml


                @sps_feed.elements.each('entry') do |entry|
                    etag=entry.attribute('etag').value
                end

            return etag
        end

=begin rdoc
    Returns the version of a worksheet extracted from its meta feed.
=end
        def sps_get_version(id)
            version=nil
            @sps_feed=@sps_client.get("https://spreadsheets.google.com/feeds/worksheets/#{id}/private/full?prettyprint=true").to_xml
            
            @sps_feed.elements.each('entry') do |entry|
                version=entry.attribute('version').value
            end

        return version
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
    Retrieve a spreadsheet from its feed.  Includes demo of PUT on spreadsheet by updating value.
=end
        def get
           @sps_feed=@sps_client.get('https://spreadsheets.google.com/feeds/spreadsheets/private/full').to_xml
            puts "HEADERS BELOW"
            puts @sps_client.headers
            puts "HEADERS ABOVE"
            @sps_feed.elements.each('entry') do |entry|
                
             
            if entry.elements['title'].text=='XML'

                puts 'title: ' + entry.elements['title'].text
              # Extract the href value from each <atom:link> 
              links = {}
              entry.elements.each('link') do |link|
                links[link.attribute('rel').value] = link.attribute('href').value
              end
              @courseurl=links['alternate'].to_s
              puts @courseurl
              @id=entry.elements['id'].text[/.com\/feeds\/spreadsheets\/(.*)/, 1]
              puts @id
              

#              text[/full\/(.*%3[aA].*)$/, 1]

                #puts @spreadsheet_client.get(@courseurl)
               
                testsheet=@spreadsheet_client.get("https://spreadsheets.google.com/feeds/worksheets/#{@id}/private/full")

          body=<<-EOF
        <entry xmlns="http://www.w3.org/2005/Atom"
        xmlns:gs="http://schemas.google.com/spreadsheets/2006">
        <id>https://spreadsheets.google.com/feeds/cells/#{@id}/od6/private/full/R2C4</id>
            <link rel="edit" type="application/atom+xml"
        href="https://spreadsheets.google.com/feeds/cells/#{@id}/od6/private/full/R2C4"/>
    <gs:rowCount>50</gs:rowCount>
            <gs:colCount>10</gs:colCount>
        <gs:cell row="2" col="4" inputValue="370"/>
        </entry>
        EOF
                        puts @sps_client.headers['If-None-Match']=entry.attribute('etag').value
                        puts @sps_client.headers.inspect
                        puts "@@@@@@@@@@@@@@@@@@@@@@@@@@"
                        puts @sps_client.inspect
                        puts "@@@@@@@@@@@@@@@@@@@@@@@@@@"
                        puts body.inspect
                response=@sps_client.put("https://spreadsheets.google.com/feeds/cells/#{@id}/od6/private/full/R2C4",body)
#                puts response.body
            end 
        end
        end
        
        def post title
            body=<<-EOF
<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns="http://www.w3.org/2005/Atom">
<category scheme="http://schemas.google.com/g/2005#kind"
term="http://schemas.google.com/docs/2007#spreadsheet"/>
<title>#{title}</title>
</entry>
EOF
           feed=@doc_client.post('http://docs.google.com/feeds/documents/private/full',body) 
        end
        #update spreadsheets cell
        
=begin rdoc
    demo of put, 
=end
        def put
              
                body=<<-EOF
<entry xmlns="http://www.w3.org/2005/Atom"
xmlns:gs="http://schemas.google.com/spreadsheets/2006">
<gs:cell row="2" col="4" inputValue="300"/>
</entry>
EOF

           feed=@sps_client.put("https://spreadsheets.google.com/feeds/cells/tlwYl5YarxIHmZRL0sxvUlw/od6/#{@headers['Authorization']}/private/full/R2C4",body)
                
        end
       
=begin rdoc
    Adds  a category to the gradebook.  First the number of categories already present should be calculated using *get_number_of_used_columns*
=end
        def add_category(category_name)
            used_col_count=self.get_number_of_used_columns
            total_col_count=self.get_colCount
            if used_col_count >=total_col_count
                self.add_column(1)
            end
            sps_id=self.sps_get_course("Roster")
            sheet=self.sps_get_sheet(sps_id)
            entry = sheet.elements['entry'] # first <atom:entry>
            entry.add_namespace('http://www.w3.org/2005/Atom')
            entry.add_namespace('gd','http://schemas.google.com/g/2005')
            entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')

            body=<<-EOF
<entry xmlns="http://www.w3.org/2005/Atom"
xmlns:gs="http://schemas.google.com/spreadsheets/2006">
<gs:cell row="1" col="#{used_col_count+1}" inputValue="#{category_name}"/>
</entry>
EOF
            tag=self.sps_get_etag("course",sps_id)
            @sps_client.headers['If-None-Match']=tag
            response=@sps_client.put("https://spreadsheets.google.com/feeds/cells/#{sps_id}/od6/private/full/R1C#{used_col_count+1}",body)             
        end
        
        
=begin rdoc
    Adds another column to the spreadsheet by upating the sheets meta data. 
=end
    def add_column(num_of_columns)

        sps_id=self.sps_get_course("Roster")
        sheet=self.sps_get_sheet(sps_id)
        col_count=0
        puts "sheet #{sheet}"
        puts "end of sheet"
        
        sheet.elements.each('entry') do |entry|
            col_count=entry.elements['gs:colCount'].text.to_i
        end
        
        total_columns=col_count+num_of_columns
        puts "sheet #{sheet}"
        puts "end of sheet"
        entry = sheet.elements['entry'] # first <atom:entry>
        puts "colcount in entry #{entry.elements['gs:colCount'].text}"
        entry.elements['gs:colCount'].text = "#{total_columns.to_i}"
        puts "colcount in entry #{entry.elements['gs:colCount'].text}"
        edit_uri = entry.elements["link[@rel='edit']"].attributes['href']
        tag=self.sps_get_etag("Roster",sps_id)
#               tag=tag.gsub! /"/, ''
        puts "entry #{entry.to_s}"
        puts "edit uri #{edit_uri}"
        entry.add_namespace('http://www.w3.org/2005/Atom')
        entry.add_namespace('gd','http://schemas.google.com/g/2005')
        entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
        puts "e attr #{entry.attributes.inspect}"
        puts response=@sps_client.put("https://spreadsheets.google.com/feeds/worksheets/0AkCuQp9zaZcbdEZmM3Zjby1HTi1rLTY0Zm9kOUttc0E/private/full/od6",entry.to_s)
             
         
    end
=begin rdoc
    Returns the number of columns in the first row that have are not blank from left to right.  Blank columns should not be used in the middle of the sheet.  
    The number of columns that are not blanked is needed to calculate where to put a new category.
=end
           
        def get_number_of_used_columns
            sps_id=self.sps_get_course("Roster")
            rows=@sps_client.get("https://spreadsheets.google.com/feeds/list/#{sps_id}/od6/private/full?prettyprint=true").to_xml
            column_headers=[]
            rows.elements.each('entry[1]//gsx:*')  do |header| 
                column_headers<<header
            end
            puts "Number of headers used #{column_headers.size}"
            return column_headers.size
        end
    
=begin rdoc
    Search for a student by name and returns an id number to be used in other commands
=end
        def search_for_sid(search)
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
    end 
end
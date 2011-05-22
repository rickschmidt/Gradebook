
require 'gdata'

module Gradebook
    class Client
    
       attr_accessor :doc_client
       attr_accessor :sps_client
       attr_accessor :doc_feed
       attr_accessor :sps_feed
       
       
        def initialize
            puts "Authenticate with Google using ClientLogin(username and password)"
        end
    
        
        def setup(username,password)
            #The DOC API must be used for creating new docs AND spreadsheets
            @doc_client = GData::Client::DocList.new
            @doc_client.clientlogin("gradebookluc","gradebookluc2011")
            
            #The Spreadsheets Client is used for everything except creation.
            @sps_client=GData::Client::Spreadsheets.new
            @sps_client.clientlogin("gradebookluc","gradebookluc2011")

   
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
           
    
    end
end

gem 'gdata2', '=1.0'
require 'csv'
module Gradebook
   class Book
       
       attr_accessor :doc_client
       attr_accessor :sps_client
       attr_accessor :doc_feed
       attr_accessor :sps_feed
       
       
       def initialize(doc_client,sps_client)
           @doc_client=doc_client
           @sps_client=sps_client
       end
       
       
=begin rdoc
    Creates a Spreadsheet with the Course Title.  Note the use of the Docs API and not the Spreadsheets.
    The Docs API is required for creation of spreadsheets.
=end
       def create(doc_client,course_name)
           @doc_client=doc_client
            body=<<-EOF
<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns="http://www.w3.org/2005/Atom">
<category scheme="http://schemas.google.com/g/2005#kind"
term="http://schemas.google.com/docs/2007#spreadsheet"/>
<title>#{course_name}</title>
</entry>
EOF
           @doc_feed=@doc_client.post('http://docs.google.com/feeds/documents/private/full',body) 
           puts @doc_feed
           
        end
        
=begin rdoc
    Returns the document id for the course that is searched for as a param.  Returns nil if no course is found.
=end
        def get_course(course)
            @doc_feed=@doc_client.get("https://documents.google.com/feeds/documents/private/full?q=#{course.to_s}&prettyprint=true").to_xml

            if @doc_feed.elements['openSearch:totalResults'].text!="0"
                @doc_feed.elements.each('entry') do |entry|
                    if entry.elements['title'].text!=""
                        puts 'Title Match:' + entry.elements['title'].text
                        @doc_id=extract_document_id_from_feed("documents",entry)
                        puts "ID for Match: " + @doc_id.to_s
                    end
                end
            else
                puts "No Document found with that course name"
                @doc_id=nil
            end

            return @doc_id
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
                @id=entry.elements['id'].text[/.com\/feeds\/documents\/private\/full\/spreadsheet%3A(.*)/, 1]
            elsif feed=="spreadsheets"
                @id=entry.elements['id'].text[/.com\/feeds\/spreadsheets\/(.*)/, 1]
            else
                puts "Invalid Feed: Must be 'documents' or 'spreadsheets'."
                @id=nil
            end
            
            return @id
        end
       
=begin rdoc
    Gets the general document feed for consumption with an authorized header.
=end
        def get_doc_feed(doc_client)
            @doc_feed=doc_client.get("https://documents.google.com/feeds/documents/private/full?prettyprint=true").to_xml
            #@doc_feed=doc_client
            return @doc_feed
        end   
        
=begin rdoc
    Gets the general spreadsheet feed for consumption with an authorized header.
=end
        def get_sps_feed(sps_client)
            @sps_feed=sps_client.get("https://spreadsheets.google.com/feeds/spreadsheets/private/full?prettyprint=true").to_xml
            return @sps_feed
        end
=begin rdoc
    Deletes spreadsheet ie. course by id.
=end
        def delete_course_with_id(id)
            doc_feed=get_doc_feed(@doc_client)
            doc_feed.elements.each('entry') do |entry|
                if entry.elements['id'].text=="https://documents.google.com/feeds/documents/private/full/spreadsheet%3A#{id}"
                    @doc_client.headers['If-Match']=entry.attribute('etag').value
                    puts "Deletehere"
                    response=@doc_client.delete("https://documents.google.com/feeds/documents/private/full/document%3A#{id}") 
                end
           end
        end
        
        
        
        
       def import_roster(doc_client,spreadsheet_client,roster)
            body=<<-EOF
<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns="http://www.w3.org/2005/Atom">
<category scheme="http://schemas.google.com/g/2005#kind"
term="http://schemas.google.com/docs/2007#spreadsheet"/>
<title>test upload roster</title>
</entry>
EOF
           @doc_client=doc_client
           # @spreadsheet_client=spreadsheet_client
           # @feed = @doc_client.get('https://docs.google.com/feeds/documents/private/full').to_xml
           # @feed.elements.each('entry') do |entry|
           #     puts "#{entry} \n"
           # end
           # puts @spreadsheet_client.headers['If-None-Match']=entry.attribute('etag').value
           #             Content-Length: 0
           #  Content-Type: application/pdf
           #  Slug: MyTitle
           #  X-Upload-Content-Type: application/pdf
           #  X-Upload-Content-Length: 1234567

            @doc_client.headers['Content-Type']='text/csv'
            @doc_client.headers['Slug']="Roster"


            bodyarray1=Array.new
            bodyarray2=Array.new
            

           puts "Roster is #{roster.inspect}"
           CSV.open(roster.path, 'r') do |row|
               bodyarray1<< row
             end
             b=<<-EOF
             ID,Name,Grade,
             12,Mike,A-,
             34,Carol,A,
             EOF
                        @doc_client.post("https://docs.google.com/feeds/documents/private/full",bodyarray1)
       end 
   end
   
   
end
#Author::Rick Schmidt


module Gradebook
=begin rdoc
	The Client class handles user authentication.  It stores the users tokens in the ~/.gb preference file and also stores the spreadsheet Id for the current course.
	A working client object is integral to the rest of the program.  It is passed in as a parameter in all base and lower level classes and instantiated in classes
	represneting user objects.
=end
    class Client
    	attr_accessor :doc_client
       	attr_accessor :sps_client
       	attr_accessor :doc_feed
       	attr_accessor :sps_feed
		attr_accessor :sps_id
		attr_reader :sps_id_path
		attr_reader :doc_token_path
		attr_reader :sps_token_path
		attr_reader :path
       
		def initialize
			#The DOC API must be used for creating new docs AND spreadsheets
			@path=File.expand_path('~/.gb')
			unless (File.exists? @path)
				Dir.mkdir(@path)
			end
			@doc_client = GData::Client::DocList.new
			@sps_client=GData::Client::Spreadsheets.new

			@doc_token_path=File.expand_path('~/.gb/doc_token')
			@sps_token_path=File.expand_path('~/.gb/sps_token')
			unless((File.exists? doc_token_path) || (File.exists? sps_token_path))
				puts "Enter Username"
				@username=STDIN.gets.chomp
				puts "Enter Password"
				system "stty -echo"
				@pwd=STDIN.gets.chomp
				system "stty echo"
				puts "Logging in..."
			end
			unless(File.exists? doc_token_path)
				#If file doesn't exist make the request, write the token and it to @doc_client
				File.new(path)	
				@doc_client.clientlogin(@username,@pwd)
				File.open(doc_token_path,"a") do |data|
					token=@doc_client.auth_handler.get_token(@username,@pwd,"gradebookluc") #Third paramter identifies app to gdata (could be anything at this point)	
					data<<token
				end
			else
				#If file does exist read the token and assign it to @doc_client
				@doc_client.auth_handler=GData::Auth::ClientLogin.new('writley')
				@doc_client.auth_handler.token=File.open(doc_token_path,'r').read
			end
	
			unless(File.exists? sps_token_path)
				#If file doesn't exist make the request, write the token and it to @sps_client
				File.new(path)
	            @sps_client.clientlogin(@username,@pwd)
				File.open(sps_token_path,"a") do |data|
					token=@sps_client.auth_handler.get_token(@username,@pwd,"gradebookluc")
					data<<token
				end
			else
				#If file does exist read the token and assign it to @sps_client
				@sps_client.auth_handler=GData::Auth::ClientLogin.new('wise')
				@sps_client.auth_handler.token=File.open(sps_token_path,'r').read		
	
			end
			
			@sps_id_path=File.expand_path('~/.gb/sps_id')
			if((File.exists? @sps_id_path) && (!File.zero? @sps_id_path))
				@sps_id=File.open(@sps_id_path,'r').read
			else
				File.open(@sps_id_path,'w')
				puts "Enter Course Name:\n"
				sps_name=STDIN.gets.chomp
				@sps_id=self.class.sps_get_course(@doc_client,sps_name)        
				File.open(@sps_id_path,"a") do |data|
					data<<@sps_id
				end
			end
			@username=''
			@pwd=''
		end

=begin rdoc
	Clears the Sps ID file from .gb preference folder.  This is used when the user is changing classes/rosters.
=end
		def clear_sps_id
			File.delete(@sps_id_path)
			@cache=Gradebook::Cache.new
			@cache.clear_cache
			puts "SPS ID Cleared"
		end
		
=begin rdoc
	Clears the users credentials from the preference folder by deleting their doc and sps token.
=end
		def clear_credentials
			File.delete(@doc_token_path)
			File.delete(@sps_token_path)
			puts "Credentials Cleared"
		end
		
    
=begin rdoc
        Used by self.sps_get_course(doc_client,course). 
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
			@sps_feed=doc_client.get("https://documents.google.com/feeds/documents/private/full?q=#{course}&prettyprint=true").to_xml
            if @sps_feed.root.elements['openSearch:totalResults'].text!="0"
				@sps_feed.root.elements.each('entry') do |entry|
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
    end 
end
require 'net/http'
require 'fileutils'

=begin rdoc
    Cache performs GET requests by first checking to see if a disk cached version exists.  If it does a conditional GET is performed with an etag extracted from the cache.
    If a response code of '304' is returned nothing has changed on line and the cached version is returned.  A response code of '200' means there is an updated version online 
    in which case another GET request is performed without the etag.  The new version is cached to disk.  If the file does not exist a full GET request is performed.  All cases return 
    an xml file.  
=end
module Gradebook
    class Cache
		
		attr_reader :cache_dir
		
		def initialize

			@cache_dir=File.expand_path('../../../tmp', __FILE__)
		end
=begin rdoc
	Clear cache
=end
		def clear_cache
			Dir.chdir(@cache_dir)
			Dir.glob("*") do |filename|
				File.unlink(filename)
			end
		end
        
=begin rdoc
    The cache is checked for an update file before the entire document is retrieved again.  In every case an XML document is returned. 
=end
      def cache_get_request(sps_client,file,url)    
		sps_client.headers.delete('If-None-Match')
        before=Time.now

          file_path = File.join("", @cache_dir, "#{file}")
          
          if (File.exists? file_path) && (!File.zero? file_path)
	
              contents=File.open(file_path,'r')             
              xml_doc=REXML::Document.new(contents)
              tag=xml_doc.root.attributes['gd:etag'].to_s
              sps_client.headers['If-None-Match']=tag
              response=sps_client.get(url)
				
				xml=REXML::Document.new(response.body).root
				
              if response.status_code==304
                  after=Time.now
#                  puts "Time: #{after-before}"
                
                  return xml_doc
              elsif response.status_code==200
                  response=sps_client.get(url).to_xml
                
                  File.open(file_path,"w") do |data|
                      data<<response
                  end
			  	contents=File.new(file_path).read             
              	xml_doc=REXML::Document.new(contents)
               	return xml_doc
              end                            
          else
          #   sps_feed=sps_client.get(url).to_xml
          # 			puts "sps_feed #{sps_feed.class}"
          # 		#	File.open(file_path, 'w') {|f| f.write(sps_feed) }
          #             puts "new #{file_path}"
          # #            File.open(file_path,"w") do |data|
          #  #               data<<sps_feed
          #   #          end              
          # 
          #           after=Time.now
          #     #      puts "SPSFEED IN CACHE2 #{sps_feed}"
          #      #     puts "Time: #{after-before}"
          # #				contents = File.open(file_path, "r")
          # 				contents=REXML::Document.new(sps_feed.to_s)
          # 			     puts "contents #{contents.inspect}"
          # 				puts "XXXXXXXX+++++++++++++++++++++++++++++++++++++++++++++++++"
          #               	xml_doc=REXML::Document.new(contents)
          # 				f=File.open(file_path, 'w') {|f| f.write(sps_feed) }
          # 				
          # 				puts "-------------------------------------"
          #                	return 
			#begin
			
			begin
					 sps_client.get(url).inspect
					sps_feed=sps_client.get(url).to_xml
						
		#			xml_doc=REXML::Document.new(sps_feed1)
			
					 # f=File.open(file_path,"w") do |data|
					 # 		                        data<<sps_feed
					 # 		                    end
			
					f=File.open(file_path, 'w') {|f| f.write(sps_feed) }
				rescue	 
					if sps_feed==nil
						puts sps_feed
						 
						
					else
						raise "Spsfeed nil"
				 	end
				end
				begin
			    	contents=File.open(file_path,'r')
				rescue SystemCallError
					contents=File.open(file_path,'r')
				
				ensure
				xml_doc=REXML::Document.new(contents)
					
			end

				return xml_doc
          end
		#return xml_doc
      end
    end
end
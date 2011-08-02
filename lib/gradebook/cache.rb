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
		attr_accessor :sps_client
		
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
		file_path = File.join("", @cache_dir, "#{file}")
          
          if (File.exists? file_path) && (!File.zero? file_path)
              contents=File.open(file_path,'r')             
              xml_doc=REXML::Document.new(contents)
             tag=xml_doc.root.attributes['gd:etag'].to_s
            sps_client.headers['If-None-Match']=tag
              response=sps_client.get(url)
				xml=REXML::Document.new(response.body).root
              if response.status_code==304
	             Gradebook::Utility::Logger.log("#{Time.now}","GET", "#{url}","Response:#{response.status_code}")
                  return xml_doc
              elsif response.status_code==200
                  response=sps_client.get(url)
				  body=response.to_xml                
                  File.open(file_path,"w") do |data|
                      data<<body
                  end
			  	contents=File.new(file_path).read             
              	xml_doc=REXML::Document.new(contents)
	             Gradebook::Utility::Logger.log("#{Time.now}","GET", "#{url}","Response:#{response.status_code}")
               	return xml_doc
              end                            
          else	
			begin				
				sps_feed=sps_client.get(url).to_xml						
				f=File.open(file_path, 'w') {|f| f.write(sps_feed) }
				attempts=0
			rescue	 
				if sps_feed==nil
					attempts=attempts.to_i+1
					retry if attempts.to_i<3 	
				else
					raise "HTTP request failed after 3 attempts"
				 end
			end
			begin
			    contents=File.open(file_path,'r')
			rescue SystemCallError
				contents=File.open(file_path,'r')
			ensure
				xml_doc=REXML::Document.new(contents)
#				Gradebook::Utility::Logger.log("#{Time.now}","GET", "#{url}","Response:#{sps_feed.status_code}")					
			end
				return xml_doc
          end
      end
    end
end
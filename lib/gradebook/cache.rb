require 'net/http'
require 'md5'

=begin rdoc
    Cache performs GET requests by first checking to see if a disk cached version exists.  If it does a conditional GET is performed with an etag extracted from the cache.
    If a response code of '304' is returned nothing has changed on line and the cached version is returned.  A response code of '200' means there is an updated version online 
    in which case another GET request is performed without the etag.  The new version is cached to disk.  If the file does not exist a full GET request is performed.  All cases return 
    an xml file.  
=end
module Gradebook
    class Cache
        
=begin rdoc
    The cache is checked for an update file before the entire document is retrieved again.  In every case an XML document is returned. 
=end
      def self.cache_get_request(sps_client,file,url)    

        before=Time.now
          cach_dir='/tmp/'
          file_path = File.join("", cach_dir, "#{file}")                      
          if (File.exists? file_path) && (!File.zero? file_path)
              contents=File.new(file_path).read             
              xml_doc=REXML::Document.new(contents)
              tag=xml_doc.root.attributes['gd:etag'].to_s
              sps_client.headers['If-None-Match']=tag
              response=sps_client.get(url)
              if response.status_code==304
                  after=Time.now
#                  puts "Time: #{after-before}"
                  puts "304"
                  puts "xmldocs in cache #{xml_doc}"
                  return xml_doc
              elsif response.status_code==200
                  response=sps_client.get(url).to_xml
                  puts "200"
                  File.open(file_path,"w") do |data|
                      data<<response
                  end
                    return response
              end                            
          else
            sps_feed=sps_client.get(url).to_xml
            puts "sps in cach #{sps_feed}"
            puts "new"
            File.open(file_path,"w") do |data|
                data<<sps_feed
            end              
          end
          after=Time.now
    #      puts "SPSFEED IN CACHE2 #{sps_feed}"
     #     puts "Time: #{after-before}"
          return sps_feed
      end
    end
end
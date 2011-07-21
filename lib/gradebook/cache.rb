require 'net/http'
require 'md5'


module Gradebook
    class Cache
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
                  puts "Time: #{after-before}"
                  puts "304"
                  return xml_doc
              elsif response.status_code==200
                  puts "200"
                  File.open(file_path,"w") do |data|
                      data<<response.body
                  end
              end                            
          else
            sps_feed=sps_client.get(url).to_xml
            puts "new"
            File.open(file_path,"w") do |data|
                data<<sps_feed
            end              
          end
          after=Time.now
          puts "Time: #{after-before}"
      end
    end
end
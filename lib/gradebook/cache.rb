require 'net/http'
require 'md5'


module Gradebook
    class Cache
        @@cache_dir='/tmp'
       def initialize(cache_dir='/tmp')
          # this is the dir where we store our cache
          @@cache_dir=cache_dir
       end
       def self.fetch(xml, max_age=0)
           puts "xml.class #{xml.class}"


           puts "inspect #{xml.attributes['gd:etag'].to_s}"
           file=''
           xml.elements.each('title') do |title|
               file=title.text
           end
#           doc=REXML::Element.new(url)


               
           puts "root #{file}"
           puts "root #{file.class}"
#          file = MD5.hexdigest(doc.root)
            puts "Cachdir class #{@@cache_dir.class}"

          file_path = File.join("", @@cache_dir, file)
          puts "Path: #{file_path}"
          # we check if the file -- a MD5 hexdigest of the URL -- exists
          #  in the dir. If it does and the data is fresh, we just read
          #  data from the file and return
          if File.exists? file_path
             return File.new(file_path).read if Time.now-File.mtime(file_path)<max_age
          end
          # if the file does not exist (or if the data is not fresh), we
          #  make an HTTP request and save it to a file
          File.open(file_path, "w") do |data|
             data <<file
          end
       end
    end
end
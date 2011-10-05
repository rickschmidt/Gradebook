
=begin rdoc
	Depracted.  TODO This file needs to be evaluated and discarded.
=end

module Gradebook
   class CreateGoogleCL
       
       def initialize
          @client=Gradebook::Client.new
          @client.setup("username","password")
          @doc_client=@client.doc_client
          @sps_client=@client.sps_client
           
       end
       def upload_roster(path_to_file)
           googlecl=Gradebook::GoogleCL.new
          @upload_url=googlecl.upload(path_to_file)
       end
       
                     
#                 body=<<-EOF
# <entry xmlns="http://www.w3.org/2005/Atom"
# xmlns:gs="http://schemas.google.com/spreadsheets/2006">
# <gs:cell row="2" col="4" inputValue="300"/>
# </entry>
# EOF
# 
#            feed=@sps_client.put("https://spreadsheets.google.com/feeds/cells/tlwYl5YarxIHmZRL0sxvUlw/od6/#{@headers['Authorization']}/private/full/R2C4",body)
       def add_category(category_name)
          create=Gradebook::Book.new(@doc_client,@sps_client)
          @doc_id=create.get_course("roster")
body=<<-EOF
<entry xmlns="http://www.w3.org/2005/Atom"
xmlns:gs="http://schemas.google.com/spreadsheets/2006">
<gs:cell row="2" col="4" inputValue="300"/>
</entry>
EOF
        etag=@client.sps_get_etag("test","0AkCuQp9zaZcbdEsyYk81dk1HSk1McExFSmJIbm9lbWc")
        etag=etag.to_s
        @sps_client.headers['If-None-Match']=etag
         feed=@sps_client.put("https://spreadsheets.google.com/feeds/cells/#{@doc_id}/od6/#{@headers['Authorization']}/private/full/R2C4",body)
#         feed=@sps_client.put("https://spreadsheets.google.com/feeds/cells/#{@doc_id}/od6/private/full/R2C4",body)
       end
   end 
end
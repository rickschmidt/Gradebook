=begin rdoc
	Author::Rick Schmidt
	This class constructs the xml for editing a grade. It is designed to be invoked from the UserGrades class.  
=end

module Gradebook
   class Grade
		attr_reader :client
		
       	def initialize(client,column_id)
			@client=client
           	@column_id=column_id			
        end

=begin rdoc
	Enter Grade constructs the xml entry for submitting a grade and invokes the PUT using the Client object and logs the result.
=end
        def enter_grade(entry,grade)
            edit_uri=''
            entry.add_namespace('http://www.w3.org/2005/Atom')
            entry.add_namespace('gd','http://schemas.google.com/g/2005')
            entry.add_namespace('gs','http://schemas.google.com/spreadsheets/2006')
            entry.add_namespace('gsx','http://schemas.google.com/spreadsheets/2006/extended')
            entry.elements.each('link') do |link|
                edit_uri = entry.elements["link[@rel='edit']"].attributes['href']
            end
            entry.elements.each("gsx:*[#{@column_id}]") do |col|
                col.text=grade
            end
            @client.sps_client.put(edit_uri,entry.to_s)
	        Gradebook::Utility::Logger.log("grades","#{Time.now}", "ColumnID: #{@column_id}", "LastName:#{entry.elements['gsx:lastname'].text}","FirstName:#{entry.elements['gsx:firstname'].text}","Grade: #{grade}","\n")
        end
   end 
end
=begin rdoc
    Logger provides functionality for writing to the logs in the programs file in ~/.gb
=end
module Gradebook
	module Utility
    	class Logger
			@dir=File.expand_path('~/.gb/log')

=begin rdoc
	A static method that performs the logging.  self.log takes the name of the log "http", "grades", etc and an unlimited list of characters.  
	The file that is being written to is locked and unlocked from being written to by other operations.  
=end	
			def self.log(log,*args)
				unless (File.exists? @dir)
					Dir.mkdir(@dir)
				end
				file_path = File.join("", @dir, log)
				File.open(file_path,"a") do |data|
					data.flock(File::LOCK_EX)
					args.each{|a| data<<a+"\n"}
					data.flock(File::LOCK_UN)			
				end
			end			
		end
	end
end


=begin rdoc
    A class for gathering basic stats 
=end
module Gradebook
	module Utility
    	class Logger
			@dir=File.expand_path('../../../../log', __FILE__)
			
			
			def self.log(*args)
				file_path = File.join("", @dir, "log")
#				thread=Thread.new{
					File.open(file_path,"a") do |data|
						data.flock(File::LOCK_EX)
						args.each{|a| data<<a+"\n"}
						data.flock(File::LOCK_UN)			
					end
				# }
				# thread.join				
			end			
		end
	end
end
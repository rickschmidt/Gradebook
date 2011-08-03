ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
require 'aruba/cucumber'
#require 'aruba'
#ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '../../../Gradebook')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

#puts "Env #{ENV['PATH']}"

# module ArubaOverrides
#   def detect_ruby_script(cmd)
#     if cmd =~ /^executable /
#       "ruby -I../../lib -S ../../bin/#{cmd}"
#     else
#       super(cmd)
#     end
#   end
# end
# 
# World(ArubaOverrides)

Before('@slow')do

	  @aruba_io_wait_seconds = 2
end
# AfterStep ('@slow2')do
# 
# #   @aruba_timeout_seconds = 20
# #  @aruba_io_wait_seconds = 5
#    	sleep(10)
# 	puts "2"
# 
# end
# 
# # AfterStep('@slow') do
# # 	
# # 	
# #   @aruba_io_wait_seconds = 5
# # #  @aruba_timeout_seconds = 20
# # end
# 
# 
# 

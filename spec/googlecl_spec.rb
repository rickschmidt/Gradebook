$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "GoogleCL" do
    
   before(:all) do
       @googlecl=Gradebook::GoogleCL.new

     end
       
     it "should create a document with googlecl" do
         file=File.expand_path('sample/roster.csv')
         @googlecl.upload(file)
         
     end
     
     it "should list the documents with a google cl instance" do
         file_list=@googlecl.list
         file_list.should_not eql(nil)
         
     end
     
     it "should get a specifc doc using google cl" do
         download_to=File.expand_path('../Resources/')
        document=@googlecl.get("roster",download_to) 
        document.should_not eql(nil)
     end
     

     
     it "should delete a specific course with google cl " do
        should fail
        @googlecl.delete('roster')
=begin
        This action is perhaps to destructive for the application.  For example if an instructor wanted to delete 
        'Gradebook Comp 313 Fall' the search may be over reaching and delete 'Gradebook Comp313 Spring' as well. 
=end
     end
 end
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "GoogleCL" do
    
   before(:each) do
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
     
     it "should edit a specific course with google cl" do
  #      @googlecl.edit('roster') 
        should fail
     end
     
     it "should delete a specific course with google cl " do
   #     @googlecl.delete('roster')
        should fail
     end
 end
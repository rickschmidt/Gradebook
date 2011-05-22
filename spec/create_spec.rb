
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "Book" do
    
   before(:all) do
       @client=Gradebook::Client.new
       @client.setup("","")
       @doc_client=@client.doc_client
       @sps_client=@client.sps_client
       
       @book=Gradebook::Book.new(@doc_client,@sps_client)
     end
       
     it "should should have a doc_client and a sps_client after setup" do
         @book.doc_client.should_not eql(nil)
         @book.sps_client.should_not eql(nil)
     end
     
     it "should be able to retrieve the gradebook for a course by searching for its title" do
        @id=@book.get_course("xml")
        @id.should_not eql(nil)
    end


end
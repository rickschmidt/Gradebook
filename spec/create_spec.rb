
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "Book" do
    
   before(:each) do
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
    
    it "should be able to create a spreadsheet with a title " do
        @book.create(@doc_client,"rspec2")
    end
     
     it "should be able to retrieve the gradebook for a course by searching for its title" do
        @id=@book.get_course("rspec2")
        @id.should_not eql(nil)
    end
        
    it "should be able to get a course id and then delete the course" do
        puts "Delete"
        id=@book.get_course("rspec2")
        @book.delete_course_with_id(id)
    end
    
    it "should be able to get a document feed" do
        xml=@book.get_doc_feed(@doc_client)
        xml.class.should eql(REXML::Element)
    end
    
    it "should be able to get a spreadsheet feed" do
       xml=@book.get_sps_feed(@sps_client)
       xml.class.should eql(REXML::Element)
    end

    it "should also use googlecl" do
        system('google documents ')
        
        
    end

end
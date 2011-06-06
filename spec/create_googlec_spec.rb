$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gradebook'


describe "CreateGoogleCL" do
    
   before(:each) do
       @googlecl=Gradebook::CreateGoogleCL.new
       
     end
       
     it "should be able to add a category" do
         @googlecl.add_category('test')
     end
     
     it "should pass"do
        client=Gradebook::Client.new
        client.setup("u","p")
        etag=client.sps_get_etag("test","0AkCuQp9zaZcbdEsyYk81dk1HSk1McExFSmJIbm9lbWc")
        puts etag
    end
 end
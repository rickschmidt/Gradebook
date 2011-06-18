$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'gdata'
include Gradebook


Given /^a sheet from searching by a file name on google docs$/ do
   @client= Client.new
   @client.setup('','')
   @sps_id= Search.sps_get_course(@client.doc_client,"Roster")
   @sheet= Search.sps_get_sheet(@client.sps_client,@sps_id)
   @rows= Search.sps_get_rows(@client.sps_client,@sps_id)
end

Then /^I should be able to get and manipulate the metadata from a sheet including adding and removing columns and listing the number of rows\.$/ do
    Utility.add_columns(1,@client.sps_client,@sheet,@sps_id)
    Utility.remove_columns(1,@client.sps_client,@sheet,@sps_id)
    Utility.add_category(@client.sps_client,@sps_id,"Cucumber Quiz",@rows,@sheet)
    Utility.get_number_of_columns(@sheet)
    Utility.get_number_of_used_columns(@rows)
    Utility.sps_get_etag(@client.sps_client,@sps_id)
    Utility.sps_get_version(@client.sps_client,@sps_id)
end


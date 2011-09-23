
# $LOAD_PATH.unshift File.expand_path("../gdata2-1/lib/gdata", __FILE__)
require 'gradebook/create'
require 'gradebook/client'
require 'gradebook/googlecl'
require 'gradebook/create_googlecl'

#require 'gradebook/utility'
require 'gradebook/utility/base'
require 'gradebook/utility/structure'
require 'gradebook/utility/function'
require 'gradebook/utility/logger'

require 'gradebook/grade'
require 'gradebook/user_grades'
require 'gradebook/cache'
require 'gdata_gradebook'

#Loads gdata2-1
require 'rubygems'

require 'gdata'
require 'gradebook/gdata_monkeypatch'

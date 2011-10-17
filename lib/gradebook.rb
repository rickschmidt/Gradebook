require 'rubygems'

require 'gdata'

require 'gradebook/config'
require 'gradebook/version'

require 'gradebook/gdata_monkeypatch'

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

require 'gradebook/mailer'




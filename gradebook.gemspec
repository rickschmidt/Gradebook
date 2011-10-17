$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'gradebook'
require 'gdata'

Gem::Specification.new do |s|
  s.name = %q{gradebook}
  s.version = "0.2.2"


  s.authors = ["Rick Schmidt"]
  s.date = %q{2011-10-17}
  s.description = %q{This gem provides a command line interface to google spreadsheets.}
  s.email = %q{rick@rickschmidt.org}
  s.summary = %q{This gem provides a command line interface for managing a gradebook on google spreadsheets.}

	s.executables<<'gb'
	
	s.add_dependency('gdata')
	s.add_dependency('actionmailer', ["= 3.0.7"])

  s.homepage = %q{http://www.github.com/rickschmidt/gradebook}
	 s.require_path="lib"
# s.files= `git 	ls-files`.split("\n")
# s.files= `ls -R | grep *.rb`.split("\n")
	rbfiles = File.join("**", "*.rb")
	erbfiles=File.join("**", "*.erb")
	s.files=Dir.glob(rbfiles)+Dir.glob(erbfiles) 


 
end

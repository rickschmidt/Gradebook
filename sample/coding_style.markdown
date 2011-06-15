Coding Style
============

Class Names/Style
Method Names/style

Dependencies
------------
*	Gems
	1.	Cucumber _testing_
	2.	Rspec	_testing_
	3.	gdata
*	Google CL _available from macports_

Google Docs vs Google Spreadsheets API
--------------------------------------

	The google data api for documents is required to create a spreadsheet ie. the spreadsheets api can only be used to work with existing spreadsheets.  
	
	The google data spreadsheets api has two different modes 1) List feed 2)Cell Feed.  The Google data api does not recommend mixing the two.  
	
	
File Structure
--------------
bin
	_contains the executable code_

doc
	_documentation_
	
features
	_contain cucumber feature descriptions and their step definitions_
	
features/step_definitions
		_contains the code that is executed during cucumber feature tests_

lib
	_contains the classes under development_
	
sample
	_sample documents used in testing such as rosters etc_
	
spec
	_contains rspec code for testing_
	

	
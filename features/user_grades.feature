Feature: a user grades class wraps many of the functions in other classes in fewer actions that represent a users interactions with the program, 
sort of a public API vs a private API.

    
    In order to build a public API that wraps some less abstracted details 
    I want to create a class to handle the common user interactions.
    
    @slow
    Scenario: User creates a category to hold grades
            When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb category new --name CucumberTest`
			Then CucumberTest should exist as a column header
				
    @slow    @remove    
    Scenario: User removes a category and grades in that category
            When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb category remove --name CucumberTest`

    
	@slow @announce @individual
    Scenario: User enters grades for an individual
            When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb grade --sid 2222` interactively
 			When I type "cuke test again2"
			When I type "A"
			Then the output should contain "grading"
			
	@slow  @announce @new
     Scenario: User enters grades for an entire class       
			When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb grade all` interactively
			When I type "cuke test again2"
			When I am grading all
			Then the output should contain "Enter grade for student:"
			
	@search
 	Scenario: User searches for the SID(Student ID) of a student using their name as a param
			When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb search --firstname mary`
			Then the output should contain "Searching for student... mary"
			
	Scenario: User should be able to read a grade report for a student by using their name as a search parameter
			When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb report --firstname mary`
			Then the output should contain "Name mary"
			
	Scenario: User should be able to read a grade report in xml format for a student by using their name as a search parameter
 			When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb report --firstname mary --out xml`
			Then the output should contain "<Grade Report>"
			
	Scenario: User should be able to read a grade report for a student by using their SID as a search parameter
			When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb report --sid 1111`
			Then the output should contain "Report"
			
	Scenario: User should be able to read a grade report in xml format for a student by using SID name as a search parameter
 			When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb report --sid 1111 --out xml`
			Then the output should contain "<Grade Report>"
			
	
			
			
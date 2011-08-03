Feature: a user grades class wraps many of the functions in other classes in fewer actions that represent a users interactions with the program, 
sort of a public API vs a private API.

    
    In order to build a public API that wraps some less abstracted details 
    I want to create a class to handle the common user interactions.
    
    
    Scenario: User creates a category to hold grades
            When I run the new category command is given with the name of a new category as a param
			
            
    Scenario: User removes a category and grades in that category
            When the remove category command is given with the name of a category as a param
    
	@slow 
	@announce
	@puts
    Scenario: User enters grades for an entire class
            When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb grade --sid 2222` interactively
 			When I type "cuke test again2"
			When I type "A"
			Then the output should contain "grading"
			
	@slow @new @announce
     Scenario: User enters grades for an entire class       
			When I run `/Users/rickschmidt/GradebookProject/Gradebook/bin/gb grade all` interactively
			When I type "cuke test again2"
			When I am grading all
			Then the output should contain "Enter grade for student:"


    
Feature: a user grades class wraps many of the functions in other classes in fewer actions that represent a users interactions with the program, 
sort of a public API vs a private API.

    
    In order to build a public API that wraps some less abstracted details 
    I want to create a class to handle the common user interactions.
    
    
    Scenario: User creates a category to hold grades
            When the new category command is given with the name of a new category as a param
            
    Scenario: User removes a category and grades in that category
            When the remove category command is given with the name of a category as a param
    
    Scenario: User enters grades for an entire class
            When the grade all command is issued each student should be graded for a category
            
    
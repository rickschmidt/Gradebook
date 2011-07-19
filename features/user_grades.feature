Feature: a user grades class wraps many of the functions in other classes in fewer actions that represent a users interactions with the program, 
sort of a public API vs a private API.

    
    In order to build a public API that wraps some less abstracted details 
    I want to create a class to handle the common user interactions.
    
    
    Scenario: User creates a new column 
            Given an authenticated client and a spreadsheet ID
            When the new category command is given with the name of a new category as a param
            Then check to see if an average column for the new category prefix exists
            Then present the user with options Y or N to update the column.
            Then if the answer is Y re-average the column.  
         
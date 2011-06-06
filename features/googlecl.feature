Feature: google command line tool is used to access google docs
    
    In order to use the gradebook 
    As an instructor
    I want to create a spreadsheet with the coures name using the command line
    
    Scenario: create a new spreadsheet with a course name using googlecl
        Given a course name
        When I receive the create command
        Then use googlecl to create the document with that name
        
        
Feature: a document is created on google docs
    
    In order to use the gradebook 
    As an instructor
    I want to create a spreadsheet with the coures name
    
    Scenario: create a new spreadsheet with a course name
        Given an authenticated doc_client 
        When I send the create command with a course name create a spreadsheet on gdocs
        Then return the id of the newly created document
        
    Scenario: create a new spreadsheet without a course name
        Given an authenticated doc_client and no course name
        When I send the create commnad without a course name created a spreadsheet called "Gradebook" with a timestamp.
        Then return the id of the newly created document
        
    Scenario: search for an existing spreadsheet on google docs
        Given an authenticated doc_client 
        Given a course search term
        When I send the get_course(course) message
        Then return an id of the first matched spreadsheet
        
        
        
    
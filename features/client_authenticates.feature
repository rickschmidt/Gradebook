Feature: client authenticates
    
    In order to connect to google spreadsheets 
    As a user of this system
    I want the user to authenticate
    
    Scenario: client authenticates successfully 
        Given a client
        When I send it the authenticate message
        Then I should have a successful authenticaion object response
        
        
    Scenario: client authentication falils
        Given a client
        When I send it hte authanticate method
        And authentication fails
        Then there should be an error
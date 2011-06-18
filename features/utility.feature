Feature: a utility class should be created for making the common easy
    
    In order to maximize the flexibility of the code 
    I want to create a utility to class to handle the common api calls that get stats on a document
    Then this information can be used in more abstracted classes.
    
    Scenario: extract metadata from a spreadsheet
        Given a sheet from searching by a file name on google docs
        Then I should be able to get and manipulate the metadata from a sheet including adding and removing columns and listing the number of rows.
         
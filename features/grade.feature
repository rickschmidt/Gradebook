Feature: a class that will insert grades for the students in a spreadsheet

    In order to grade a student
    I want to ask what category the grades are for and identify this column assuming it exists at first
    I then want to show each student in turn and insert a grade for each one
    
    Scenario: the cateogry already exists
        Given a column id after searching for a category name
        When I issue the grade command
        Then reveal the students names sequentially each time asking for which grade should be inserted
        Then insert the grade in the studnets row and the cateogry column








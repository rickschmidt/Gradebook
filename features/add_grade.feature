Feature: add grade for a student
    
    In order to add a grade for a student
    I first need to connect to the gradebook sheet
    Then I  need to choose a category to be graded
    Then I need to select the student by their ID and enter a grade.
    
    Scenario: instructor wants to enter a grade for each student in the sheet row by row
        Given a gradebook
        When I send the grade all command
        Then ask what category this grade should be filed under
        Then add a column for the category to the gradebook
        Then start presenting students names and prompt for grade.
        Then after each grade is entered print the students name and grade as confirmation.
        Then continue until all students have been had their grades done.
        
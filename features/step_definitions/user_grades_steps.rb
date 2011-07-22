$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'gdata'
include Gradebook



When /^the new category command is given with the name of a new category as a param$/ do
    user_grades=Gradebook::Usergrades.new
    user_grades.new_category('cuke-cucumbertest')
end

When /^the remove category command is given with the name of a category as a param$/ do
    user_grades=Gradebook::Usergrades.new
    user_grades.remove_category('cuke-cucumbertest')
end

When /^the grade all command is issued each student should be graded for a category$/ do
   user_grades=Gradebook::Usergrades.new
   user_grades.grade_all 
end




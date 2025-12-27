local maniaGrades = {}

maniaGrades.getGrade = function(accuracy)
    if not accuracy then return end
    local grades = maniaGrades.getGrades_PLURAL_that_is_grades_WITH_AN_S__this_function_gives_you_the_TABLE_of_grades___this_is_NOT_the_one_that_gives_the_current_grade_when_you_pass_in_an_accuracy___that_is_the_OTHER_similarly_named_function_called_getGrade__that_is_not_THIS_one()
    for i, grade in ipairs(grades) do
        if accuracy >= grade.accuracy then
            return grade.grade
        end
    end
end

maniaGrades.getGrades_PLURAL_that_is_grades_WITH_AN_S__this_function_gives_you_the_TABLE_of_grades___this_is_NOT_the_one_that_gives_the_current_grade_when_you_pass_in_an_accuracy___that_is_the_OTHER_similarly_named_function_called_getGrade__that_is_not_THIS_one = function()
    return {
        {grade = "S+", accuracy = 100},
        {grade = "S", accuracy = 95},
        {grade = "A", accuracy = 90},
        {grade = "B", accuracy = 80},
        {grade = "C", accuracy = 70},
        {grade = "D", accuracy = 0},
        {grade = "F", accuracy = 0},

    }
end

return maniaGrades
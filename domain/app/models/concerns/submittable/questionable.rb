module Questionable
  def submit_question!(user, question)
    assignment, _ = find_assignment_and_submit! user, Question.new
    assignment.send_question!(question)
  end
end

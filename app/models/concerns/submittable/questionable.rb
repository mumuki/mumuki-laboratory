module Questionable
  def submit_question!(user, question)
    submit! user, Question.new unless assigned_to? user
    assignment_for(user).send_question! question
  end
end

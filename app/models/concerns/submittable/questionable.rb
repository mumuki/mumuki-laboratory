module Questionable
  def submit_question!(user, question)
    submit! user, Question.new 
    assignment_for(user).send_question! question
  end
end

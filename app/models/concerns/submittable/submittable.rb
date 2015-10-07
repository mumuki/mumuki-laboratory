module Submittable
  def submit!(user, submission)
    assignment = find_or_init_assignment_for user
    create_evaluation(assignment, submission).run!
  end

  def create_evaluation(assignment, submission)
    evaluation_class.new(assignment, submission)
  end

  def evaluation_class
    Evaluation
  end
end
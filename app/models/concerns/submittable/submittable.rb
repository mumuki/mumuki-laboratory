module Submittable
  def submit!(user, submission)
    assignment = find_or_init_assignment_for user
    Evaluation.new(assignment, submission).run!
  end
end
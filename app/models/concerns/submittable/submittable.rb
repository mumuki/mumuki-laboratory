module Submittable
  def submit!(user, submission)
    assignment = find_or_init_assignment_for user
    evaluation_class.new(assignment, submission).run!
  end
end

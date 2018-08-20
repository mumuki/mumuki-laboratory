module Submittable
  def submit!(user, submission)
    find_assignment_and_submit!(user, submission).last
  end

  def find_assignment_and_submit!(user, submission)
    assignment = assignment_for user
    results = submission.run! assignment, evaluation_class.new
    [assignment, results]
  end
end

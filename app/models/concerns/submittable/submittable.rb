module Submittable
  def submit!(user, submission)
    assignment = find_or_init_assignment_for user
    evaluation_class.new(assignment, submission).run!
  end

  def evaluation_class
    if manual_evaluation?
      manual_evaluation_class
    else
      automated_evaluation_class
    end
  end

  def manual_evaluation_class
    ManualEvaluation
  end

  def automated_evaluation_class
    AutomatedEvaluation
  end
end
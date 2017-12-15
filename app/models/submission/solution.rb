class Solution < PersistentSubmission
  attr_accessor :content

  def try_evaluate_exercise!(user, exercise)
    exercise.run_tests!(user, content: content).except(:response_type)
  end
end

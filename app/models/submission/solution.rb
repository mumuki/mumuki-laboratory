class Solution < PersistentSubmission
  attr_accessor :content

  def try_evaluate_exercise!(exercise)
    exercise.run_tests!(content: content).except(:response_type)
  end
end

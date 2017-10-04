class Solution < PersistentSubmission
  attr_accessor :content

  def try_evaluate_against!(exercise)
    exercise.run_tests!(content: content).except(:response_type)
  end
end

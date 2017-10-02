class Solution < PersistentSubmission
  attr_accessor :content

  def try_evaluate_against!(assignment)
    assignment.run_tests!(content: content).except(:response_type)
  end
end

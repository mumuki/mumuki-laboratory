class Solution < PersistentSubmission
  attr_accessor :content, :content_metadata

  def try_evaluate!(assignment)
    assignment.run_tests!(content: content).except(:response_type)
  end
end

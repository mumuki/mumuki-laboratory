class PersistentSubmission < Submission
  def setup_assignment!(assignment)
    assignment.running!
    super
    assignment.persist_submission! self
  end
end

class PersistentSubmission < Submission
  def save_submission!(assignment)
    assignment.running!
    super
    assignment.persist_submission! self
  end
end

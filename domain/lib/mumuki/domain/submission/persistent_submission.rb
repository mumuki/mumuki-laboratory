class Mumuki::Domain::Submission::PersistentSubmission < Mumuki::Domain::Submission::Base
  def save_submission!(assignment)
    assignment.running!
    super
    assignment.persist_submission! self
  end
end

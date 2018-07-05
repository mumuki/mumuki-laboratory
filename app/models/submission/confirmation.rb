class Confirmation < PersistentSubmission
  def content
    nil
  end

  def try_evaluate!(*)
    {status: Mumuki::Laboratory::Status::Submission::Passed, result: ''}
  end
end

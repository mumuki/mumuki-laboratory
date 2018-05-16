class Confirmation < PersistentSubmission
  def content
    nil
  end

  def try_evaluate!(*)
    {status: Mumuki::Laboratory::Status::Assignment::Passed, result: ''}
  end
end

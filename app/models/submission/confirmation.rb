class Confirmation < PersistentSubmission
  def content
    nil
  end

  def try_evaluate!(*)
    {status: Mumuki::Laboratory::Status::Passed, result: ''}
  end
end

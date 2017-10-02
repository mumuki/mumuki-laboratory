class Confirmation < PersistentSubmission
  def content
    nil
  end

  def try_evaluate_against!(*)
    {status: Status::Passed, result: ''}
  end
end

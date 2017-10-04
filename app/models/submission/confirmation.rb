class Confirmation < PersistentSubmission
  def content
    nil
  end

  def try_evaluate_exercise!(*)
    {status: Status::Passed, result: ''}
  end
end

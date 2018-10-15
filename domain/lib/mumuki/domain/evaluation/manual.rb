class Mumuki::Domain::Evaluation::Manual
  def evaluate!(*)
    {status: Mumuki::Domain::Status::Submission::ManualEvaluationPending, result: ''}
  end
end

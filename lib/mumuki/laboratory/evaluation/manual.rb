class Mumuki::Laboratory::Evaluation::Manual
  def evaluate!(*)
    {status: Mumuki::Laboratory::Status::Submission::ManualEvaluationPending, result: ''}
  end
end

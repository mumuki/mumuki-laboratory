class Mumuki::Laboratory::Evaluation::Manual
  def evaluate!(*)
    {status: Mumuki::Laboratory::Status::Assignment::ManualEvaluationPending, result: ''}
  end
end

class Mumuki::Laboratory::Evaluation::Manual
  def evaluate!(*)
    {status: Mumuki::Laboratory::Status::ManualEvaluationPending, result: ''}
  end
end

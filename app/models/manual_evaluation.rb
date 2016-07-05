class ManualEvaluation < Evaluation
  def evaluate!
    {status: Status::ManualEvaluationPending, result: ''}
  end
end
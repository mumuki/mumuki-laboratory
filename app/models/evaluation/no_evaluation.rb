class NoEvaluation < Evaluation
  def evaluate!
    {status: Status::Passed, result: ''}
  end
end

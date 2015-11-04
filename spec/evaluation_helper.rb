class NoopEvaluation < Evaluation
  def evaluate!
    {status: Status::Failed, result: 'noop result'}
  end
end

class Exercise
  def evaluation_class
    NoopEvaluation
  end
end

Assignment.class_eval do
  def failed!
    update_attributes!(status: Status::Failed)
  end
end
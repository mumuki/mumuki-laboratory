module WithTestRunning
  def run_tests!
    run_update! do
      exercise.run_tests!(content: solution).except(:response_type)
    end
    EventSubscriber.notify_async!(Event::Submission.new(self))
  end
end

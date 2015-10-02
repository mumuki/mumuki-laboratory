class Solution
  include ActiveModel::Model

  attr_accessor :content, :assignment

  def run!
    assignment.run_update! do
      assignment.exercise.run_tests!(content: content).except(:response_type)
    end
    EventSubscriber.notify_async!(Event::Submission.new(assignment))
  end
end

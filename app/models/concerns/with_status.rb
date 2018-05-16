module WithStatus
  extend ActiveSupport::Concern

  included do
    serialize :status, Mumuki::Laboratory::Status::Assignment
    validates_presence_of :status
  end

  def passed?
    status.passed?
  end

  def aborted?
    status == :aborted
  end

  def run_update!
    running!
    begin
      update! yield
    rescue => e
      errored! e.message
      raise e
    end
  end

  def passed!
    update! status: :passed
  end

  def running!
    update! status: :running,
            result: nil,
            test_results: nil,
            expectation_results: [],
            manual_evaluation_comment: nil
  end

  def errored!(message)
    update! result: message, status: :errored
  end

end

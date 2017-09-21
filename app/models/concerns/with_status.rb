module WithStatus
  extend ActiveSupport::Concern

  included do
    serialize :status, Status
    validates_presence_of :status
  end

  def passed?
    status.passed?
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

  def running!
    update! running_state
  end

  def passed!
    update! status: Status::Passed
  end

  def errored!(message)
    update! result: message, status: Status::Errored
  end

  def running_state
    {status: Status::Running}
  end

end

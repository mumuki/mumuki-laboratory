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
    update! status: Status::Running
    begin
      update! yield
    rescue => e
      update! result: e.message, status: Status::Errored
      raise e
    end
  end

end

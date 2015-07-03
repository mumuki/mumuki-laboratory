module WithStatus
  extend ActiveSupport::Concern

  included do
    enum status: [:pending, :running, :passed, :failed, :errored, :aborted, :passed_with_warnings]
    validates_presence_of :status
  end

  def run_update!
    update! status: :running
    begin
      update! yield
    rescue => e
      update! result: e.message, status: :errored
      raise e
    end
  end

  module ClassMethods
    def passed_status
      statuses[:passed]
    end
    def failed_status
      statuses[:failed]
    end
  end
end

module WithStatus
  extend ActiveSupport::Concern

  included do
    enum status: [:pending, :running, :passed, :failed]
    validates_presence_of :status
  end

  def run_update!
    update! status: :running
    begin
      update! yield
    rescue => e
      update! result: e.message, status: :failed
      raise e
    end
  end
end

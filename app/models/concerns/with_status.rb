module WithStatus
  enum status: [:pending, :running, :passed, :failed]

  def run_update!
    update! status: :running
    begin
      result, status = yield
      update! result: result, status: status
    rescue => e
      update! result: e.message, status: :failed
      raise e
    end
  end
end
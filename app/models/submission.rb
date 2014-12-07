class Submission < ActiveRecord::Base
  include Compilation

  enum status: [:pending, :running, :passed, :failed]

  belongs_to :exercise
  belongs_to :user

  validates_presence_of :exercise

  after_commit :run_tests!, on: :create

  delegate :language, :plugin, to: :exercise

  def run_tests!
    TestRunnerJob.new.async.perform(id)
  end

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




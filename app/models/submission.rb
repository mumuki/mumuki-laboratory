class Submission < ActiveRecord::Base
  include Compilation
  include TestRunning

  enum status: [:pending, :running, :passed, :failed]

  belongs_to :exercise
  belongs_to :submitter, class_name: 'User'

  validates_presence_of :exercise, :submitter

  after_create :update_submissions_count!
  after_commit :schedule_test_run!, on: :create

  delegate :language, :plugin, to: :exercise

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

  private

  def update_submissions_count!
    self.class.connection.execute(
        "update exercises
         set submissions_count = submissions_count + 1
        where id = #{exercise.id}")
    exercise.reload
  end
end




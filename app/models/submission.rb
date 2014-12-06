class Submission < ActiveRecord::Base
  enum status: [:pending, :running, :passed, :failed]

  belongs_to :exercise
  belongs_to :user

  validates_presence_of :exercise

  after_commit :run_tests!, on: :create

  delegate :language, :plugin, to: :exercise

  def run_tests!
    TestRunnerJob.new.async.perform(id)
  end
end




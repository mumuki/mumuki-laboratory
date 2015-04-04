class Submission < ActiveRecord::Base
  include TestRunning
  include WithStatus

  belongs_to :exercise
  belongs_to :submitter, class_name: 'User'

  validates_presence_of :exercise, :submitter

  serialize :expectation_results

  after_create :update_submissions_count!
  after_commit :schedule_test_run!, on: :create

  delegate :language, :title, to: :exercise

  def should_retry?
    failed? || expectation_results.any? { |it| it[:result] == :failed } #TODO rename result => status
  end

  def result_preview
    result.truncate(100) if failed?
  end

  def eligible_for_run?
    exercise.submissions_for(submitter).last == self
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




class Submission < ActiveRecord::Base
  include WithTestRunning
  include WithStatus

  extend WithAsyncAction

  belongs_to :exercise
  belongs_to :submitter, class_name: 'User'

  validates_presence_of :exercise, :submitter

  serialize :expectation_results

  after_create :update_submissions_count!
  after_create :update_last_submission!

  schedule_on_create TestRunnerJob

  delegate :language, :title, to: :exercise

  scope :by_exercise_ids, -> (exercise_ids) {
    where(exercise_id: exercise_ids) if exercise_ids
  }

  scope :by_usernames, -> (usernames) {
    joins(:submitter).where('users.name' => usernames) if usernames
  }

  def should_retry?
    failed? || expectation_results.any? { |it| it[:result] == :failed } #TODO rename result => status
  end

  def results_visible?
    exercise.visible_success_output || should_retry?
  end

  def result_preview
    result.truncate(100) if failed?
  end

  def eligible_for_run?
    exercise.submissions_for(submitter).last == self
  end

  def result_html
    language.output_to_html(result)
  end

  def feedback_html
    language.output_to_html(feedback)
  end

  def content_html
    ContentType::Markdown.to_html "```#{language.highlight_mode}\n#{content}\n```"
  end

  def expectation_results_visible?
    visible_expectation_results.present?
  end

  def visible_expectation_results
    (expectation_results||[]).select { |it| it[:result] == :failed }
  end

  private

  def update_submissions_count!
    self.class.connection.execute(
        "update exercises
         set submissions_count = submissions_count + 1
        where id = #{exercise.id}")
    exercise.reload
  end

  def update_last_submission!
    submitter.update!(last_submission_date: created_at, last_exercise: exercise)
  end
end




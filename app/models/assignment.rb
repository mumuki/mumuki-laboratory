class Assignment < ActiveRecord::Base
  include WithStatus

  belongs_to :exercise
  has_one :guide, through: :exercise
  has_many :messages, -> { order('date DESC') }, foreign_key: :submission_id, primary_key: :submission_id

  belongs_to :submitter, class_name: 'User'


  validates_presence_of :exercise, :submitter

  serialize :expectation_results
  serialize :test_results

  delegate :language, :name, :visible_success_output?, to: :exercise
  delegate :output_content_type, to: :language
  delegate :should_retry?, to: :status

  scope :by_exercise_ids, -> (exercise_ids) {
    where(exercise_id: exercise_ids) if exercise_ids
  }

  scope :by_usernames, -> (usernames) {
    joins(:submitter).where('users.name' => usernames) if usernames
  }

  def results_visible?
    visible_success_output? || should_retry?
  end

  def result_preview
    result.truncate(100) if should_retry?
  end

  def result_html
    output_content_type.to_html(result)
  end

  def feedback_html
    output_content_type.to_html(feedback)
  end

  def expectation_results_visible?
    visible_expectation_results.present?
  end

  def visible_expectation_results
    StatusRenderingVerbosity.visible_expectation_results(status, expectation_results || [])
  end

  def accept_new_submission!(submission)
    transaction do
      messages.destroy_all
      update! submission_id: submission.id
      update_submissions_count!
      update_last_submission!
    end
  end

  def send_message!(message_data)
    Message.create! message_data.merge(submission_id: submission_id, exercise_id: exercise_id)
    has_messages!
  end

  def has_messages!
    update! has_messages: true
  end

  def empty_chat?
    !has_messages
  end

  def pending_messages?
    messages.exists? read: false
  end

  def extension
    exercise.language.extension
  end

  def notify!
    Event::Submission.new(self).notify!
  end

  def notify_to_accessible_organizations!
    submitter.accessible_organizations.each do |organization|
      organization.switch!
      notify!
    end
  end

  private

  def update_submissions_count!
    self.class.connection.execute(
      "update public.exercises
         set submissions_count = submissions_count + 1
        where id = #{exercise.id}")
    self.class.connection.execute(
      "update public.assignments
         set submissions_count = submissions_count + 1
        where id = #{id}")
    exercise.reload
  end

  def update_last_submission!
    submitter.update!(last_submission_date: DateTime.now, last_exercise: exercise)
  end
end

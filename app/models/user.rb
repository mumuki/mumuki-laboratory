class User < ApplicationRecord
  include WithProfile,
          WithUserNavigation,
          WithReminders,
          Mumukit::Platform::User::Helpers

  serialize :permissions, Mumukit::Auth::Permissions

  has_many :assignments, foreign_key: :submitter_id

  has_many :messages, -> { order(created_at: :desc) }, through: :assignments

  has_many :submitted_exercises, through: :assignments, class_name: 'Exercise', source: :exercise

  has_many :solved_exercises,
           -> { where('assignments.status' => Mumuki::Laboratory::Status::Passed.to_i) },
           through: :assignments,
           class_name: 'Exercise',
           source: :exercise

  belongs_to :last_exercise, class_name: 'Exercise', optional: true
  belongs_to :last_organization, class_name: 'Organization', optional: true

  has_one :last_guide, through: :last_exercise, source: :guide

  has_many :exam_authorizations

  after_initialize :init

  def last_lesson
    last_guide.try(:lesson)
  end

  def submissions_count
    assignments.pluck(:submissions_count).sum
  end

  def passed_submissions_count
    passed_assignments.count
  end

  def submitted_exercises_count
    submitted_exercises.count
  end

  def solved_exercises_count
    solved_exercises.count
  end

  def passed_assignments
    assignments.where(status: Mumuki::Laboratory::Status::Passed.to_i)
  end

  def unread_messages
    messages.where read: false
  end

  def visit!(organization)
    update!(last_organization: organization) if organization != last_organization
  end

  def to_s
    "#{id}:#{name}:#{uid}"
  end

  def never_submitted?
    last_submission_date.nil?
  end

  def clear_progress!
    transaction do
      update! last_submission_date: nil, last_exercise: nil
      assignments.destroy_all
    end
  end

  def transfer_progress_to!(another)
    transaction do
      assignments.update_all(submitter_id: another.id)
      if another.never_submitted? || last_submission_date.try { |it| it > another.last_submission_date }
        another.update! last_submission_date: last_submission_date,
                        last_exercise: last_exercise,
                        last_organization: last_organization
      end
    end
    reload
  end

  def self.import_from_json!(body)
    User.where(uid: body[:uid]).update_or_create!(body.except(:id))
  end

  def unsubscribe_from_reminders!
    update! accepts_reminders: false
  end

  def self.unsubscription_verifier
    Rails.application.message_verifier(:unsubscribe)
  end

  def notify!
    Mumukit::Nuntius.notify_event! 'UserChanged', user: as_platform_json
  end

  private

  def init
    self.image_url ||= "user_shape.png"
  end
end

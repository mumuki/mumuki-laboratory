class User < ApplicationRecord
  include WithProfile,
          WithUserNavigation,
          WithReminders,
          WithDiscussionCreation,
          Mumukit::Platform::User::Helpers

  serialize :permissions, Mumukit::Auth::Permissions

  has_many :assignments, foreign_key: :submitter_id

  has_many :messages, -> { order(created_at: :desc) }, through: :assignments

  has_many :submitted_exercises, through: :assignments, class_name: 'Exercise', source: :exercise

  has_many :solved_exercises,
           -> { where('assignments.submission_status' => Mumuki::Domain::Status::Submission::Passed.to_i) },
           through: :assignments,
           class_name: 'Exercise',
           source: :exercise

  belongs_to :last_exercise, class_name: 'Exercise', optional: true
  belongs_to :last_organization, class_name: 'Organization', optional: true

  has_one :last_guide, through: :last_exercise, source: :guide

  has_many :exam_authorizations

  has_many :exams, through: :exam_authorizations

  after_initialize :init

  before_validation :set_uid!

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
    assignments.where(status: Mumuki::Domain::Status::Submission::Passed.to_i)
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

  def accept_invitation!(invitation)
    make_student_of! invitation.course
  end

  def copy_progress_to!(another)
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

  def self.import_from_resource_h!(json)
    json = Mumukit::Platform::User::Helpers.slice_platform_json json
    User.where(uid: json[:uid]).update_or_create!(json)
  end

  def unsubscribe_from_reminders!
    update! accepts_reminders: false
  end

  def self.unsubscription_verifier
    Rails.application.message_verifier(:unsubscribe)
  end

  def attach!(role, course)
    add_permission! role, course.slug
    save_and_notify!
  end

  def detach!(role, course)
    remove_permission! role, course.slug
    save_and_notify!
  end

  def self.create_if_necessary(user)
    user[:uid] ||= user[:email]
    where(uid: user[:uid]).first_or_create(user)
  end

  def interpolations
    {
      'user_email' => email,
      'user_first_name' => first_name,
      'user_last_name' => last_name
    }
  end

  def resubmit!(organization = nil)
    organization = Organization.find_by_name(organization) || main_organization
    organization.switch!
    assignments.each { |it| it.notify! rescue nil }
  end

  def currently_in_exam?
    exams.any? { |e| e.in_progress_for? self }
  end

  private

  def set_uid!
    self.uid ||= email
  end

  def init
    self.image_url ||= "user_shape.png"
  end
end

class Exam < ApplicationRecord
  include GuideContainer
  include FriendlyName

  validates_presence_of :start_time, :end_time

  belongs_to :guide
  belongs_to :organization

  has_many :authorizations, class_name: 'ExamAuthorization', dependent: :delete_all
  has_many :users, through: :authorizations

  after_destroy { |record| Usage.destroy_usages_for record }

  include TerminalNavigation

  def used_in?(organization)
    organization == self.organization
  end

  def enabled?
    enabled_range.cover? DateTime.now
  end

  def enabled_range
    start_time..end_time
  end

  def enabled_for?(user)
    enabled_range_for(user).cover? DateTime.now
  end

  def in_progress_for?(user)
    accessible_for?(user) && started?(user)
  end

  def validate_accessible_for!(user)
    if user.present?
      raise Mumuki::Domain::ForbiddenError unless authorized?(user)
      raise Mumuki::Domain::GoneError unless enabled_for?(user)
    else
      raise Mumuki::Domain::UnauthorizedError
    end
  end

  def accessible_for?(user)
    authorized?(user) && enabled_for?(user)
  end

  def timed?
    duration.present?
  end

  def authorize!(user)
    users << user unless authorized?(user)
  end

  def authorized?(user)
    users.include? user
  end

  def enabled_range_for(user)
    start_time..real_end_time(user)
  end

  def authorization_for(user)
    authorizations.find_by(user_id: user.id)
  end

  def authorizations_for(users)
    authorizations.where(user_id: users.map(&:id))
  end

  def start!(user)
    authorization_for(user).start! unless user.teacher_here?
  end

  def started?(user)
    authorization_for(user).try(:started?)
  end

  def real_end_time(user)
    if duration.present? && started?(user)
      [started_at(user) + duration.minutes, end_time].min
    else
      end_time
    end
  end

  def started_at(user)
    authorization_for(user).started_at
  end

  def process_users(users)
    users.map { |user| authorize! user }
    clean_authorizations users
  end

  def clean_authorizations(users)
    authorizations.all_except(authorizations_for(users)).destroy_all
  end

  def self.import_from_resource_h!(json)
    exam_data = json.with_indifferent_access
    organization = Organization.find_by!(name: exam_data[:organization])
    organization.switch!
    adapt_json_values exam_data
    remove_previous_version exam_data[:eid], exam_data[:guide_id]
    exam = where(classroom_id: exam_data[:eid]).update_or_create!(whitelist_attributes(exam_data))
    exam.process_users exam_data[:users]
    exam.index_usage! organization
    exam
  end

  def self.adapt_json_values(exam)
    exam[:guide_id] = Guide.find_by(slug: exam[:slug]).id
    exam[:organization_id] = Organization.current.id
    exam[:users] = exam[:uids].map { |uid| User.find_by(uid: uid) }.compact
    [:start_time, :end_time].each { |param| exam[param] = exam[param].to_time }
  end

  def self.remove_previous_version(eid, guide_id)
    Rails.logger.info "Looking for"
    where("guide_id=? and organization_id=? and classroom_id!=?", guide_id, Organization.current.id, eid).tap do |exams|
      Rails.logger.info "Deleting exams with ORG_ID:#{Organization.current.id} - GUIDE_ID:#{guide_id} - CLASSROOM_ID:#{eid}"
      exams.destroy_all
    end
  end

  def attempts_left_for(assignment)
    max_attempts_for(assignment.exercise) - (assignment.attempts_count || 0)
  end

  def limited_for?(exercise)
    max_attempts_for(exercise).present?
  end

  def resettable?
    false
  end

  private

  def max_attempts_for(exercise)
    exercise.choice? ? max_choice_submissions : max_problem_submissions
  end
end

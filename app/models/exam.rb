class Exam < ActiveRecord::Base
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

  def access!(user)
    if user.present?
      raise Exceptions::ForbiddenError unless authorized?(user)
      raise Exceptions::GoneError unless enabled_for?(user)
    else
      raise Exceptions::UnauthorizedError
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
    authorization_for(user).start! unless user.teacher?
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

  def self.import_from_json!(json)
    json.except!(:social_ids, :sender)
    organization = Organization.find_by!(name: json.delete(:organization))
    organization.switch!
    exam_data = parse_json json
    remove_previous_version exam_data[:eid], exam_data[:guide_id]
    users = exam_data.delete(:users)
    exam = where(classroom_id: exam_data.delete(:eid)).update_or_create! exam_data
    exam.process_users users
    exam.index_usage! organization
    exam
  end

  def self.parse_json(exam_json)
    exam = exam_json.except(:name, :language)
    exam[:guide_id] = Guide.find_by(slug: exam.delete(:slug)).id
    exam[:organization_id] = Organization.current.id
    exam[:users] = exam.delete(:uids).map { |uid| User.find_by(uid: uid) }.compact
    [:start_time, :end_time].each { |param| exam[param] = exam[param].to_time }
    exam
  end

  def self.remove_previous_version(eid, guide_id)
    Rails.logger.info "Looking for"
    where("guide_id=? and organization_id=? and classroom_id!=?", guide_id, Organization.current.id, eid).tap do |exams|
      Rails.logger.info "Deleting exams with ORG_ID:#{Organization.current.id} - GUIDE_ID:#{guide_id} - CLASSROOM_ID:#{eid}"
      exams.destroy_all
    end
  end
end

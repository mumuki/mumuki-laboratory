class Exam < ActiveRecord::Base
  include GuideContainer
  include FriendlyName

  validates_presence_of :duration, :start_time, :end_time

  belongs_to :guide
  belongs_to :organization

  has_many :exam_authorizations

  include TerminalNavigation

  def used_in?(organization)
    organization == self.organization
  end

  def enabled?
    enabled_range.cover? DateTime.now
  end

  def accesible_by?(user)
    enabled? && authorized?(user)
  end

  def authorize!(user)
    users << user
  end

  def authorized?(user)
    users.include? user
  end

  def enabled_range
    start_time..end_time
  end

  def exam?
    true
  end

  def authorization_for(user)
    exam_authorizations.find_by(user_id: user.id)
  end

  def start! user
    authorization_for(user).start!
  end

  def started? user
    authorization_for(user).started?
  end

  def self.import_from_json!(json)
    Organization.find_by!(name: json.delete('tenant')).switch!
    exam_data = Exam.parse_json json
    users = exam_data.delete('users')
    e = Exam.where(classroom_id: exam_data.delete('classroom_id')).first_or_create exam_data
    users.map { |user| e.authorize! user}
    Organization.current.index_usage! e.guide, e
  end

  def self.parse_json(exam_json)
    exam = exam_json.except('name', 'language')
    exam['guide_id'] = Guide.find_by(slug: exam.delete('slug')).id
    exam['organization_id'] = Organization.current.id
    exam['users'] = exam.delete('social_ids').map { |sid| User.find_by(uid: sid) }
    ['start_time', 'end_time'].each { |param| exam[param] = exam[param].to_time }
    exam
  end
end

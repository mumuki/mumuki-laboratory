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
    authorization_for(user).start! unless user.teacher?(Mumukit::Auth::Slug.join_s(Organization.current.name))
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
    users.map { |user| authorize! user}
    clean_authorizations users
  end

  def clean_authorizations(users)
    authorizations.all_except(authorizations_for(users)).destroy_all
  end
end

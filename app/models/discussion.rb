class Discussion < ApplicationRecord
  include WithDiscussionStatus, ParentNavigation, Searchable

  belongs_to :item, polymorphic: true
  has_many :messages
  belongs_to :initiator, class_name: 'User'
  belongs_to :submission, optional: true

  before_save :capitalize
  validates_presence_of :title

  delegate :language, to: :item

  scope :for_user, -> (user) do
    if user.try(:moderator?)
      all
    else
      where.not(status: :closed).or(where(initiator: user))
    end
  end

  scope :for_status, -> (status) { where(status: status) }

  def capitalize
    title.capitalize!
    description.try(:capitalize!)
  end

  def used_in?(organization)
    item.used_in?(organization).present?
  end

  def friendly
    title
  end

  def submit_message!(message, user)
    message.merge!(sender: user.uid)
    messages.create(message)
  end

  def authorized?(user)
    initiator?(user) || user.moderator?
  end

  def initiator?(user)
    user.try(:uid) == initiator.uid
  end

  def reachable_statuses_for(user)
    return [] unless authorized?(user)
    reachable_statuses
  end

  def reachable_status_for?(user, status)
    reachable_statuses_for(user).include? status
  end

  def allowed_statuses_for(user)
    status.allowed_statuses_for(user, self)
  end

  def update_status!(status, user)
    update!(status: status) if reachable_status_for?(user, status)
  end

  def self.sortable_fields
    [:created_at]
  end
end

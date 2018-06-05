class Discussion < ApplicationRecord
  include WithDiscussionStatus, ParentNavigation

  belongs_to :item, polymorphic: true
  has_many :messages
  belongs_to :initiator, class_name: 'User'
  belongs_to :submission

  before_save :capitalize
  validates_presence_of :title

  scope :for_questioner, -> (questioner) { where.not(status: :closed).or(where(status: :closed, initiator: questioner)).order(status: :desc, created_at: :asc) }
  scope :for_helper, -> { order(status: :asc, created_at: :asc) }

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
    user.uid == initiator.uid
  end

  def allowed_statuses_for(user)
    return [] unless authorized?(user)
    reachable_statuses
  end

  def allowed_status_for?(user, status)
    allowed_statuses_for(user).include? status
  end

  def update_status!(status, user)
    update!(status: status) if allowed_status_for?(user, status)
  end
end

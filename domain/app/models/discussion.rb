class Discussion < ApplicationRecord
  include WithDiscussionStatus, ParentNavigation, WithScopedQueries, Contextualization

  belongs_to :item, polymorphic: true
  has_many :messages, -> { order(:created_at) }, dependent: :delete_all
  belongs_to :initiator, class_name: 'User'
  belongs_to :exercise, foreign_type: :exercise, foreign_key: 'item_id'
  has_many :subscriptions
  has_many :upvotes

  scope :by_language, -> (language) { includes(:exercise).joins(exercise: :language).where(languages: {name: language}) }

  before_save :capitalize_title
  validates_presence_of :title

  markdown_on :description

  sortable :created_at, :upvotes_count, default: :created_at_desc
  filterable :status, :language
  pageable

  delegate :language, to: :item
  delegate :to_discussion_status, to: :status

  scope :for_user, -> (user) do
    if user.try(:moderator?)
      all
    else
      where.not(status: :closed).where.not(status: :pending_review).or(where(initiator: user))
    end
  end

  def try_solve!
    if opened?
      update! status: reachable_statuses_for(initiator).first
    end
  end

  def capitalize_title
    title.capitalize!
  end

  def used_in?(organization)
    item.used_in?(organization)
  end

  def commentable_by?(user)
    user&.moderator? || (opened? && user.present?)
  end

  def subscribable?
    opened? || solved?
  end

  def has_submission?
    submission.solution.present?
  end

  def read_by?(user)
    subscription_for(user).read
  end

  def last_message_date
    messages.last&.created_at || created_at
  end

  def friendly
    title
  end

  def subscription_for(user)
    subscriptions.find_by(user: user)
  end

  def upvote_for(user)
    upvotes.find_by(user: user)
  end

  def unread_subscriptions(user)
    subscriptions.where.not(user: user).map(&:unread!)
  end

  def submit_message!(message, user)
    message.merge!(sender: user.uid)
    messages.create(message)
    unread_subscriptions(user)
  end

  def authorized?(user)
    initiator?(user) || user.try(:moderator?)
  end

  def initiator?(user)
    user.try(:uid) == initiator.uid
  end

  def reachable_statuses_for(user)
    return [] unless authorized?(user)
    status.reachable_statuses_for(user, self)
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

  def has_messages?
    messages.exists? || description.present?
  end

  def responses_count
    messages.where.not(sender: initiator.uid).count
  end

  def has_responses?
    responses_count > 0
  end

  def extra_preview_html
    # FIXME this is buggy, because the extra
    # may have changed since the submission of this discussion
    exercise.assignment_for(initiator).extra_preview_html
  end

  def self.debatable_for(klazz, params)
    debatable_id = params[:"#{klazz.underscore}_id"]
    klazz.constantize.find(debatable_id)
  end
end

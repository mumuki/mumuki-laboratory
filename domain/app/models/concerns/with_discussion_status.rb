module WithDiscussionStatus
  extend ActiveSupport::Concern

  included do
    serialize :status, Mumuki::Domain::Status::Discussion
    validates_presence_of :status
    scope :by_status, -> (status) { where(status: status) }
  end

  delegate :closed?, :opened?, :solved?, :pending_review?, :reachable_statuses, to: :status
end

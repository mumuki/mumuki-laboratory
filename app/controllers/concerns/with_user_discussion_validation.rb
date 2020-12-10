module WithUserDiscussionValidation
  extend ActiveSupport::Concern

  included do
    # users are not allowed to access discussions during exams
    before_action :validate_not_blocked_in_forum!
    # discussions are not enabled for all organizations nor all users
    before_action :validate_user_can_discuss!
  end

  private

  def validate_not_blocked_in_forum!
    raise Mumuki::Domain::BlockedForumError if current_user&.currently_in_exam?
  end

  def validate_user_can_discuss!
    raise Mumuki::Domain::NotFoundError unless current_user&.can_discuss_here?
  end
end

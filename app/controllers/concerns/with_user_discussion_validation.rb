module WithUserDiscussionValidation
  extend ActiveSupport::Concern

  included do
    # discussions are not enabled for all organizations nor all users
    before_action :validate_user_can_discuss!
  end

  private

  def validate_user_can_discuss!
    raise Mumuki::Domain::NotFoundError unless current_user&.can_discuss_here?
  end
end

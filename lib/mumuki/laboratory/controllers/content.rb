module Mumuki::Laboratory::Controllers::Content
  extend ActiveSupport::Concern

  included do
    before_action :validate_used_here!, only: :show
  end

  # ensures contents are in current organization's path
  def validate_used_here!
    raise Mumuki::Laboratory::NotFoundError unless subject&.used_in?(Organization.current)
  end
end

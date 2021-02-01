module Mumuki::Laboratory::Controllers::Content
  extend ActiveSupport::Concern

  included do
    before_action :validate_used_here!, only: :show
  end

  # ensures contents are in current organization's path
  def validate_used_here! #TODO refactor subject logic (e.g. we can't move validate_accessible! here because ExerciseSolutionsController does not declare a subject)
    raise Mumuki::Domain::NotFoundError unless subject_used_here?
  end

  def subject_used_here?
    subject&.used_in?(Organization.current)
  end
end

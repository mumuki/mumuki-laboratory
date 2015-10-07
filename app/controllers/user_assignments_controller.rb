class UserAssignmentsController < ApplicationController
  include NestedInUser

  before_action :authenticate!
  def index
    @assignments = paginated @user.assignments.order(updated_at: :desc), 50
  end
end

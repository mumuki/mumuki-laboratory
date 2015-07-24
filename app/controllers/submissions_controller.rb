class SubmissionsController < ApplicationController
  include NestedInUser

  before_action :authenticate!
  def index
    @submissions = paginated @user.submissions.order(updated_at: :desc), 50
  end
end

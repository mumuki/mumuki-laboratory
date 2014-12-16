class SubmissionsController < ApplicationController
  before_filter :authenticate!
  def index
    @submissions = paginated current_user.submissions
  end
end

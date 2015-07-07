class SubmissionsController < ApplicationController #FIXME remove
  before_action :authenticate!
  def index
    @submissions = paginated current_user.submissions
  end
end

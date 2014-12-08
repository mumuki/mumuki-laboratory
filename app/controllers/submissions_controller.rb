class SubmissionsController < ApplicationController
  before_filter :authenticate!
  def index
    @submissions = current_user.submissions
  end
end

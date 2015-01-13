class DashboardController < ApplicationController

  before_action :authenticate!

  def show
    @submissions = current_user.submissions
    @exercises = current_user.exercises
    @guides = current_user.guides
  end
end

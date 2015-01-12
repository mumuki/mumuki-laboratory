class HomeController < ApplicationController

  def index
    @latest_exercises = Exercise.all
    @hottest_exercises = Exercise.order(submissions_count: :desc).limit(5)
    @guides = Guide.all
    @users = User.all
    if current_user?
      @my_exercises = current_user.exercises
      @my_submissions = current_user.submissions
    end
  end
end

class HomeController < ApplicationController

  def index
    @latest_exercises = Exercise.last(5).reverse
    @hottest_exercises = Exercise.order(:submissions_count).limit(5)
    if current_user?
      @my_exercises = current_user.exercises
      @my_submissions = current_user.submissions
    end
  end
end

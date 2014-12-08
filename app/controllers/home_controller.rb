class HomeController < ApplicationController

  def index
    @latest_exercises = Exercise.last(5).reverse
    @hottest_exercises = Exercise.order(:submissions_count).limit(5)
    if current_user?
      @my_exercises = current_user.exercises.first(10).reverse
      @my_submissions = current_user.submissions.first(10).reverse
    end
  end
end

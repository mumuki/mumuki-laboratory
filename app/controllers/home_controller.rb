class HomeController < ApplicationController

  def index
    @latest_exercises = Exercise.last(5).reverse
    @hottest_exercises = Exercise.order(:submissions_count).limit(5)
    @my_exercises = []
    @my_submissions = []
  end
end

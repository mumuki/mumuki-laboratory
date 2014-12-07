class HomeController < ApplicationController

  def index
    @latest_exercises = Exercise.last(5).reverse
    @my_exercises = []
    @my_submissions = []
  end
end

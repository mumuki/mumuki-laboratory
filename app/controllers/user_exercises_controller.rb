class UserExercisesController < ApplicationController
  include NestedInUser

  def index
    @exercises = paginated @user.exercises
  end
end

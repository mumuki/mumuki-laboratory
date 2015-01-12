class UserExercisesController < ApplicationController
  include WithExerciseIndex
  include NestedInUser

  private

  def exercises
    @user.exercises
  end
end

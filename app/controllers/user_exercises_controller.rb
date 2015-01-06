class UserExercisesController < ApplicationController
  include WithExerciseIndex
  before_action :set_user

  private

  def exercises
    @user.exercises
  end

  def set_user
    @user = User.find(params[:user_id])
  end

end

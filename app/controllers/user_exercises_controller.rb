class UserExercisesController < ApplicationController
  before_action :set_user

  def index
    #TODO duplicated logic in exercise controller

    @exercises  = paginated @user.exercises.by_tag params[:tag]
    render 'exercises/index'
  end


  private

  def set_user
    @user = User.find(params[:user_id])
  end

end

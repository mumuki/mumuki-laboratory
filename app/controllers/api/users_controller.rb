module Api
  class UsersController < BaseController
    include UsersControllerTemplate
    before_action :authorize_janitor!

    def create
      @user.save_and_notify!
      render json: @user.to_resource_h
    end

    def update
      @user.update_and_notify! user_params.except([:email, :permissions, :uid])
      render json: @user.to_resource_h
    end
  end
end

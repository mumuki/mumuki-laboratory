module Api
  class UsersController < BaseController
    include UsersControllerTemplate
    before_action :authorize_janitor!

    def create
      @user.save!
      @user.notify!
      render json: @user.as_platform_json
    end

    def update
      @user.update! user_params.except([:email, :permissions, :uid])
      @user.notify!
      render json: @user.as_platform_json
    end
  end
end

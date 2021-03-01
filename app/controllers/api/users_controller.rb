module Api
  class UsersController < BaseController
    include UsersControllerTemplate
    before_action :authorize_janitor!

    def create
      @user.save_and_notify!
      render json: @user.to_resource_h
    end

    def update
      @user.assign_attributes user_name_params
      @user.verify_name!
      render json: @user.to_resource_h
    end
  end
end

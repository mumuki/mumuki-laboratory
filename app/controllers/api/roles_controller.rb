module Api
  class RolesController < BaseController
    include WithUserParams

    before_action :set_slug!
    before_action :set_course!
    before_action :set_user!, except: :create
    before_action :authorize_janitor!

    def create
      @user = User.create_if_necessary(user_params)
      @user.attach! role, @course
      render json: @user
    end

    def attach
      @user.attach! role, @course
      head :ok
    end

    def detach
      @user.detach! role, @course
      head :ok
    end

    private

    def role
      raise 'Not Implemented'
    end

    def user_params
      params.require(role).permit(*permissible_params)
    end

    def permissible_params
      super + [:image_url, :email, :uid]
    end

    def set_course!
      @course = Course.find_by!(slug: @slug)
    end

    def set_user!
      @user = User.find_by!(uid: params[:uid])
    end

    def set_slug!
      @slug = Mumukit::Auth::Slug.join_s params.to_unsafe_h
    end

    def authorization_slug
      @slug
    end
  end

end

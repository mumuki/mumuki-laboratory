module UsersControllerTemplate
  extend ActiveSupport::Concern
  include WithUserParams

  included do
    before_action :set_user!, only: [:show, :update]
    before_action :set_new_user!, only: :create
    before_action :protect_permissions_assignment!, only: [:create, :update]
    after_action :verify_user_name!, only: :create
  end

  private

  def verify_user_name!
    @user.verify_name!
  end

  def protect_permissions_assignment!
    current_user.protect_permissions_assignment! user_params[:permissions], @user.permissions_was
  end

  def permissible_params
    super + [:email, :image_url, :verified_first_name, :verified_last_name, permissions: Mumukit::Auth::Roles::ROLES]
  end

  def set_user!
    @user = User.locate! params[:id]
  end

  def set_new_user!
    @user = User.new user_params
  end
end

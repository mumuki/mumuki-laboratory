module NestedInUser
  extend ActiveSupport::Concern
  included do
    before_action :set_user
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end

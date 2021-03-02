module WithUserParams
  extend ActiveSupport::Concern

  def user_params
    params.require(:user).permit(*permissible_params).to_h
  end

  def user_name_params
    params.require(:user).permit(:first_name, :last_name).to_h
  end

  def permissible_params
    User.profile_fields
  end
end

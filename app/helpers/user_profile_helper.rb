module UserProfileHelper
  def user_profile_path(tab=nil)
    "#{user_path}##{tab}"
  end
end

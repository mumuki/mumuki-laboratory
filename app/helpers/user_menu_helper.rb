module UserMenuHelper
  def profile_user_menu_link
    link_to t(:profile), user_path
  end
end

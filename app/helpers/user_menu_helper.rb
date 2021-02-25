module UserMenuHelper
  def profile_user_menu_link
    link_to t(:profile), user_path
  end

  def messages_user_menu_link
    link_to t(:messages), messages_user_path
  end

  def discussions_user_menu_link
    link_to t(:discussions), discussions_user_path
  end
end

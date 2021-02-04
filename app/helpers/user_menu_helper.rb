module UserMenuHelper
  def profile_user_menu_link
    user_menu_link t(:my_profile), user_path, 'show'
  end

  def messages_user_menu_link
    user_menu_link t(:messages), messages_user_path, 'messages'
  end

  def discussions_user_menu_link
    user_menu_link t(:discussions), discussions_user_path, 'discussions'
  end

  def certificates_user_menu_link
    user_menu_link t(:certificates), certificates_user_path, 'certificates'
  end

  def user_menu_link(label, path, active_on)
    link_klass = 'active' if action_name == active_on
    link_to label, path, { class: link_klass }.compact
  end
end

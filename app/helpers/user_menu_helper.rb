module UserMenuHelper
  def user_menu_header
    content_tag :div, fa_icon('chevron-up', text: t(:my_account), id: 'mu-user-menu-header-icon'), class: 'mu-user-menu-header'
  end

  def user_menu_divider
    content_tag :div, '', class: 'mu-user-menu-divider horizontal'
  end

  def profile_user_menu_link
    user_menu_item t(:my_profile), user_path, 'show'
  end

  def messages_user_menu_link
    user_menu_item t(:messages), messages_user_path, 'messages'
  end

  def discussions_user_menu_link
    user_menu_item t(:discussions), discussions_user_path, 'discussions' if current_user&.can_discuss_here?
  end

  def certificates_user_menu_link
    user_menu_item t(:certificates), certificates_user_path, 'certificates'
  end

  private

  def user_menu_item(label, path, active_on)
    link_klass = 'active' if action_name == active_on
    content_tag :div, link_to(label, path, { class: link_klass }.compact), class: 'mu-user-menu-item'
  end
end

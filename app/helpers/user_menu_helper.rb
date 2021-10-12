module UserMenuHelper
  def user_menu_header
    content_tag :div, user_menu_header_icon, class: 'mu-user-menu-header'
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

  def activity_user_menu_link
    user_menu_item t(:activity), activity_user_path, 'activity'
  end

  def certificates_user_menu_link
    user_menu_item t(:certificates), certificates_user_path, 'certificates'
  end

  def exam_authorizations_user_menu_link
    user_menu_item t(:exams), exam_authorizations_user_path, 'exam_authorizations'
  end

  def notifications_user_menu_link
    user_menu_item t(:notifications), notifications_user_path, 'notifications'
  end

  def delete_account_user_menu_link
    user_menu_item t(:delete_account), delete_account_user_path, 'delete_account', 'text-danger'
  end

  private

  def user_menu_item(label, path, active_on, link_klass = '')
    active_klass = 'active' if action_name == active_on
    content_tag :div, link_to(label, path, { class: "#{link_klass} #{active_klass}" }.compact), class: 'mu-user-menu-item'
  end

  def user_menu_header_icon
    fa_icon('chevron-down', text: t(:my_account), id: 'mu-user-menu-header-icon', right: true)
  end
end

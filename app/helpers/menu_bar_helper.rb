module MenuBarHelper
  def menu_bar_links
    [
      link_to_classroom,
      link_to_bibliotheca,
      solve_discussions_link,
      user_discussions_link
    ]
  end

  def menu_bar_list_items
    menu_bar_links.compact.map { |link| "<li>#{link}<li>".html_safe }.join
  end

  def link_to_classroom
    link_to_application 'graduation-cap', :classroom, :teacher_here?
  end

  def link_to_bibliotheca
    link_to_application :book, :bibliotheca, :writer?
  end

  def link_to_application(icon, app_name, minimal_permissions)
    return unless current_user&.send(minimal_permissions)
    url = url_for_application(app_name)

    link_to fixed_fa_icon(icon, text: t(app_name)), url, role: 'menuitem', tabindex: '-1'
  end
end

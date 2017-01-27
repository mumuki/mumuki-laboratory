module MenuBarHelper
  def link_to_classroom
    link_to_application 'graduation-cap', :classroom, Organization.classroom_url, :teacher?
  end

  def link_to_bibliotheca
    link_to_application :book, :bibliotheca, ApplicationRoot.bibliotheca.base_url, :writer?
  end

  def link_to_office
    link_to_application :clipboard, :office, ApplicationRoot.office.base_url, :janitor?
  end

  def link_to_application(icon, app_name, url, minimal_permission)
    link_to fixed_fa_icon(icon, text: t(app_name)), url if (current_user? && current_user.send(minimal_permission))
  end
end

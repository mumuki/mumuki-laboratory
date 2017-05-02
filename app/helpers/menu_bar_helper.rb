module MenuBarHelper
  def link_to_classroom
    link_to_application 'graduation-cap', :classroom, :teacher?
  end

  def link_to_bibliotheca
    link_to_application :book, :bibliotheca, :writer?
  end

  def link_to_office
    link_to_application :clipboard, :office, :janitor?
  end

  def link_to_application(icon, app_name, minimal_permissions)
    return unless current_user&.send(minimal_permissions)

    app = Mumukit::Platform.application_for(app_name)
    url = app.organic_url(Organization.current.name)

    link_to fixed_fa_icon(icon, text: t(app_name)), url
  end
end

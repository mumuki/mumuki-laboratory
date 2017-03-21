module MenuBarHelper
  def link_to_classroom
    link_to_application 'graduation-cap',
                        :classroom,
                        :teacher?,
                        subdominated: true
  end

  def link_to_bibliotheca
    link_to_application :book, :bibliotheca, :writer?
  end

  def link_to_office
    link_to_application :clipboard, :office, :janitor?
  end

  def link_to_application(icon, app_name, minimal_permissions, options={})
    return unless current_user&.send(minimal_permissions)

    app = ApplicationRoot.send(app_name)
    url = options[:subdominated] ? app.subdominated_url(Organization.current.name) : app.url

    link_to fixed_fa_icon(icon, text: t(app_name)), url
  end
end

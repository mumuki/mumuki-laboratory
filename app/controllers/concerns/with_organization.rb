module WithOrganization
  def set_organization!
    organization = Organization.by_custom_domain(request.domain) || Organization.find_by!(name: organization_name)
    organization.switch!
  rescue => e
    Organization.central.switch!
    raise e
  end

  def set_cookie_domain!
    return unless Organization.current.settings.laboratory_custom_domain
    Mumukit::Login.configure do |config|
      config.mucookie_domain = Organization.current.settings.laboratory_custom_domain
    end
  end

  def organization_name
    Mumukit::Platform.organization_name(request)
  end

  def visit_organization!
    current_user.visit!(Organization.current)
  end
end

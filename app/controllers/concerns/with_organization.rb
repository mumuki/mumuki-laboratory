module WithOrganization
  def set_organization!
    organization = Organization.by_custom_domain(request.domain) || Organization.find_by!(name: organization_name)
    organization.switch!
  rescue => e
    Organization.central.switch!
    raise e
  end

  def organization_name
    Mumukit::Platform.organization_name(request)
  end

  def visit_organization!
    current_user.visit!(Organization.current)
  end
end

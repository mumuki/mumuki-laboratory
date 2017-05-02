module WithOrganization
  def set_organization!
    Organization.find_by!(name: organization_name).switch!
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

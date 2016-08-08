module WithOrganization
  def set_organization!
    Organization.find_by!(name: request.organization_name).switch!
  end

  def visit_organization!
    current_user.visit!(Organization.current)
  end

  def implicit_central?
    !(request.first_subdomain == 'central') && Organization.central?
  end
end

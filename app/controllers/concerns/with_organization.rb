module WithOrganization
  def set_organization!
    Organization.find_by!(name: first_subdomain).switch!
  end

  def first_subdomain
    request.first_subdomain_after(Rails.configuration.domain) || 'central'
  end

  def visit_organization!
    current_user.visit!(Organization.current)
  end
end

module WithOrganizationChooser

  def should_choose_organization?
    current_user? && current_user.has_accessible_organizations? && request.empty_subdomain?
  end

end

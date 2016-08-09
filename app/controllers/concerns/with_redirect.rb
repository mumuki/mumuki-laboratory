module WithRedirect

  def should_choose_organization?
    current_user? && current_user.has_accessible_organizations? && from_internet? && request.empty_subdomain?
  end

end

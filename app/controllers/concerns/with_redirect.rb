module WithRedirect

  def should_choose_organization?
    current_user? && current_user.has_accessible_organizations? && from_internet? && implicit_central?
  end

end

module WithOrganizationChooser

  def should_choose_organization?
    current_user? && current_user.has_accessible_organizations? && Mumukit::Platform.implicit_organization?(request)
  end

end

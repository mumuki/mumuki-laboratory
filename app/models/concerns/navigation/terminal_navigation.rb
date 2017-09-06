module TerminalNavigation
  def navigation_end?
    true
  end

  def friendly
    name
  end

  def navigable_name
    name
  end

  def used_in?(organization)
    organization == self.organization
  end

  def usage_in_organization(organization = Organization.current)
    self if used_in?(organization)
  end

  def structural_parent
    organization
  end
end

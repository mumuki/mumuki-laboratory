module OrganizationListHelper
  def organizations_for(user)
    (user.accessible_organizations + [Organization.central]).uniq.compact
  end
end

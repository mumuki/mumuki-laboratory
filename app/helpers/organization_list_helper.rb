module OrganizationListHelper
  def organizations_for(user)
    user.immersive_organizations_at(nil)
  end
end

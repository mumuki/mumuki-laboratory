module OrganizationListHelper
  def organizations_for(user)
    (user.accessible_organizations + [Organization.central]).uniq.compact
  end

  def organization_switch_url(organization)
    organization.url_for(controller_name == 'users' ? root_path : request.path)
  end
end

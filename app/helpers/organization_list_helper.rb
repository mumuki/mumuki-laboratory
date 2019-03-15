module OrganizationListHelper
  def organizations_for(user)
    (user.student_granted_organizations + [Organization.central]).uniq.compact
  end
end

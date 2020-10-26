module OrganizationListHelper
  def organizations_for(user)
    # TODO use immersive contexts here
    (user.student_granted_organizations + [Organization.central]).uniq.compact
  end
end

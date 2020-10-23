module Mumuki::Laboratory::Controllers::CurrentOrganization
  def set_current_organization!
    Organization.find_by!(name: organization_name).switch!
  rescue => e
    Organization.base.switch!
    raise e
  end

  def organization_name
    Mumukit::Platform.organization_name(request)
  end

  def visit_organization!
    current_user.visit!(Organization.current)
  end
end

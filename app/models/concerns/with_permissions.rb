module WithPermissions
  extend ActiveSupport::Concern

  included do
    Mumukit::Auth::Roles::ROLES.each do |selector|
      role = "#{selector}?"
      define_method(role.to_sym) {|resource_slug| permissions.send role, resource_slug}
    end
  end

  def set_permissions!(permissions)
    Mumukit::Auth::Store.set! self.email, permissions
  end

  def permissions
    Mumukit::Auth::Store.get self.email
  end

  def accessible_organizations
    permissions.accessible_organizations.map {|org| Organization.find_by(name: org)}.compact
  end

  def has_accessible_organizations?
    accessible_organizations.present?
  end

end

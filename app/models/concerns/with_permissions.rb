module WithPermissions
  extend ActiveSupport::Concern

  included do
    [:student?, :teacher?].each do |role|
      define_method(role) { permissions.send role, Organization.slug}
    end
  end

  def set_permissions!(permissions)
    Mumukit::Auth::Store.set! self.uid, permissions
  end

  def permissions
    Mumukit::Auth::Store.get self.uid
  end

  def accessible_organizations
    permissions.accessible_organizations.map {|org| Organization.find_by(name: org)}.compact
  end

  def has_accessible_organizations?
    accessible_organizations.present?
  end

end

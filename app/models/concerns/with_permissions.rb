module WithPermissions
  extend ActiveSupport::Concern

  included do
    serialize :permissions, Mumukit::Auth::Permissions

    delegate :writer?, :janitor?, to: :permissions
  end

  def student?
    permissions.student? Organization.current.slug
  end

  def teacher?
    permissions.teacher? Organization.current.slug
  end

  def accessible_organizations
    permissions.accessible_organizations.map { |org| Organization.find_by(name: org) }.compact
  end

  def has_accessible_organizations?
    accessible_organizations.present?
  end

end

module OnBaseOrganizationOnly
  extend ActiveSupport::Concern

  included do
    before_action :ensure_base_organization!
  end

  def ensure_base_organization!
    raise ActionController::RoutingError, 'API must be called from base organization' unless Organization.current.base?
  end
end

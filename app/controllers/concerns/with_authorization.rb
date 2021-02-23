module WithAuthorization
  extend ActiveSupport::Concern

  (Mumukit::Auth::Roles::ROLES - [:editor, :writer]).each do |role|
    define_method "authorize_#{role}!" do
      authorize! role
    end
  end

  def authorization_slug
    protection_slug || '_/_'
  end

  def protection_slug
    @slug
  end
end

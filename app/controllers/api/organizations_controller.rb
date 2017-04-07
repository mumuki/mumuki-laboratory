class Api::OrganizationsController < Api::BaseController
  include WithOrganization
  before_action :set_organization!

  def index
    organization = Organization.current
    render json: { organization: organization.as_json(except: [:login_methods]).merge(locale: organization.locale, lock_json: organization.login_settings.lock_json) }
  end
end

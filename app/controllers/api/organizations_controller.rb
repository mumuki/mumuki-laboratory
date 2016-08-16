class Api::OrganizationsController < Api::BaseController
  def index
    organization = Organization.find_by(name: params[:name])
    render json: { organization: organization.as_json(except: [:login_methods]).merge(locale: organization.locale, lock_json: organization.login_settings.lock_json) }
  end
end

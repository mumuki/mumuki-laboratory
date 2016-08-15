class Api::OrganizationsController < Api::BaseController
  def index
    organization = Organization.find_by(name: params[:name])
    render json: { organization: organization.as_json(except: [:login_methods]).merge(login_settings: organization.login_settings.lock_login_methods) }
  end
end

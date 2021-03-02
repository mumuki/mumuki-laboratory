module Api
  class BaseController < ActionController::Base
    Mumukit::Login.configure_controller! self

    protect_from_forgery with: :null_session

    include Mumuki::Laboratory::Controllers::DynamicErrors
    include Mumuki::Laboratory::Controllers::CurrentOrganization

    before_action :set_current_organization!

    include OnBaseOrganizationOnly

    before_action :verify_api_client!

    private

    def verify_api_client!
      ApiClient.verify_token! Mumukit::Auth::Token.extract_from_header(request.env['HTTP_AUTHORIZATION'])
    end
  end
end

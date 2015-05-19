module Api
  class BaseController < ActionController::Base
    protect_from_forgery with: :null_session

    before_action :authenticate!

    def authenticate!
      authenticate_or_request_with_http_basic { |u, p| ApiToken.find_by(client_id: u, client_secret: p) }
    end
  end
end

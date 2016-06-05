module WithDynamicErrors
  extend ActiveSupport::Concern

  included do
   # rescue_from Organization::Unauthorized, with: :unauthorized
    rescue_from Exception, with: :internal_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::RoutingError, with: :not_found
  end

  private

  def internal_server_error
    render 'errors/internal_server_error', status: 500
  end

  def not_found
    render 'errors/not_found', status: 404
  end

end

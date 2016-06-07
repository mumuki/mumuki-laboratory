module WithDynamicErrors
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :internal_server_error
    rescue_from ActionController::RoutingError, with: :not_found
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Exceptions::OrganizationPrivateException, with: :unauthorized
    rescue_from Exceptions::ExamForbiddenException, with: :forbidden
    rescue_from Exceptions::ExamGoneException, with: :gone
  end

  private

  def internal_server_error
    render 'errors/internal_server_error', status: 500
  end

  def not_found
    render 'errors/not_found', status: 404
  end

  def unauthorized
    render 'errors/unauthorized', status: 401
  end

  def forbidden
    render 'errors/forbidden', status: 403
  end

  def gone
    render 'errors/gone', status: 410
  end

end

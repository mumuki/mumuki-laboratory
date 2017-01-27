module WithDynamicErrors
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :internal_server_error
    unless Rails.application.config.consider_all_requests_local
      rescue_from ActionController::RoutingError, with: :not_found
    end
    #FIXME maybe we can user more Mumukit::Auth::Exceptions here
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Mumukit::Auth::UnauthorizedAccessError, with: :forbidden
    rescue_from Exceptions::NotFoundError, with: :not_found
    rescue_from Exceptions::ForbiddenError, with: :forbidden
    rescue_from Exceptions::UnauthorizedError, with: :unauthorized
    rescue_from Exceptions::GoneError, with: :gone
  end

  def not_found
    render 'errors/not_found', status: 404
  end

  private

  def internal_server_error(exception)
    Rails.logger.error "Internal server error: #{exception} \n#{exception.backtrace.join("\n")}"
    render 'errors/internal_server_error', status: 500
  end


  def unauthorized
    render 'errors/unauthorized', status: 401
  end

  def forbidden
    Rails.logger.info "Access to organization #{Organization.current} was forbidden to user #{current_user} with permissions #{current_user.permissions}"
    render 'errors/forbidden', status: 403
  end

  def gone
    render 'errors/gone', status: 410
  end

end

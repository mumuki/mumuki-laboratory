module Mumuki::Laboratory::Controllers::DynamicErrors
  extend ActiveSupport::Concern

  included do
    unless Rails.application.config.consider_all_requests_local
      rescue_from Exception, with: :internal_server_error
      rescue_from ActionController::RoutingError, with: :not_found
    end
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Mumukit::Auth::UnauthorizedAccessError, with: :forbidden
    rescue_from Mumuki::Laboratory::NotFoundError, with: :not_found
    rescue_from Mumuki::Laboratory::ForbiddenError, with: :forbidden
    rescue_from Mumuki::Laboratory::UnauthorizedError, with: :unauthorized
    rescue_from Mumuki::Laboratory::GoneError, with: :gone
    rescue_from Mumuki::Laboratory::BlockedForumError, with: :blocked_forum
  end

  def not_found
    render_error 'not_found', 404, formats: [:html]
  end

  def internal_server_error(exception)
    Rails.logger.error "Internal server error: #{exception} \n#{exception.backtrace.join("\n")}"
    render_error 'internal_server_error', 500
  end

  def unauthorized
    render_error 'unauthorized', 401
  end

  def forbidden
    Rails.logger.info "Access to organization #{Organization.current} was forbidden to user #{current_user} with permissions #{current_user.permissions}"
    render_error 'forbidden', 403, locals: { explanation: :forbidden_explanation }
  end

  def blocked_forum
    render_error 'forbidden', 403, locals: { explanation: :blocked_forum_explanation }
  end

  def gone
    render_error 'gone', 410
  end

  def render_error(template, status, options={})
    if request.path.start_with? '/api/'
      render json: { message: template.gsub('_', ' ') }, status: status
    else
      render "errors/#{template}", options.merge(status: status)
    end
  end

end

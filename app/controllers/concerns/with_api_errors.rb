module WithApiErrors
  # TODO we should extend DynamiceErrors
  extend ActiveSupport::Concern

  included do
    unless Rails.application.config.consider_all_requests_local
      rescue_from ActionController::RoutingError, with: :not_found!
    end

    rescue_from ActiveRecord::RecordNotFound, with: :not_found!
    rescue_from Mumukit::Auth::UnauthorizedAccessError, with: :forbidden!
    rescue_from ActiveRecord::RecordInvalid, with: :bad_record!
  end

  private

  def bad_record!(e)
    render_errors! e.record.errors, 400
  end

  def not_found!(e)
    render_error! e, 404
  end

  def forbidden!(e)
    render_error! e, 403
  end

  def render_error!(e, status)
    render_errors! [e.message], status
  end

  def render_errors!(errors, status)
    summary = { errors: errors }
    render json: summary, status: status
  end
end

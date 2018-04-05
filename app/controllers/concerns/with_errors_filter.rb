module WithErrorsFilter
  extend ActiveSupport::Concern

  included do
    around_action :catch_exceptions
    rescue_from Exception do |e| catch_unhandled_errors(e) end
  end

  def catch_exceptions
    yield
  rescue ActiveRecord::RecordInvalid => e
    render! e.record.errors
  end

  def catch_unhandled_errors(e)
    summary = {
        errors: {
            :exception => "#{e.class.name} : #{e.message}"
        }
    }
    summary[:trace] = e.backtrace[0, 10] if Rails.env.development?

    render json: summary, status: :internal_server_error
  end

  private

  def render!(errors)
    summary = { errors: errors }
    render json: summary, status: :bad_request
  end
end
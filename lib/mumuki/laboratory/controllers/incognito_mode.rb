module Mumuki::Laboratory::Controllers::IncognitoMode
  extend ActiveSupport::Concern

  included do
    helper_method :current_incognito_user?,
                  :current_logged_user?
  end

  def current_user?
    super || incognito_mode_enabled?
  end

  def current_user
    @current_user ||= incognito_mode_enabled? ? (super rescue Mumuki::Domain::Incognito) : super
  end

  def current_incognito_user?
    current_user? && current_user.incognito?
  end

  def current_logged_user?
    current_user? && !current_user.incognito?
  end

  def incognito_mode_enabled?
    !from_sessions? && Organization.current.incognito_mode_enabled?
  end
end

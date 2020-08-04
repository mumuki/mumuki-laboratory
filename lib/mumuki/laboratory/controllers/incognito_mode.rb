module Mumuki::Laboratory::Controllers::IncognitoMode
  extend ActiveSupport::Concern

  included do
    helper_method :incognito_mode?
  end

  def current_user?
    super || Organization.current.incognito_mode_enabled?
  end

  def current_user
    @current_user ||= Organization.current.incognito_mode_enabled? ? (super rescue Mumuki::Domain::Incognito) : super
  end

  def incognito_mode?
    current_user? && current_user.incognito?
  end
end

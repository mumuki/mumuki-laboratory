module LoginCustomization
  extend ActiveSupport::Concern

  included do
    validates_presence_of :login_methods
    validate :ensure_consistent_public_login
  end

  def login_settings
    @login_settings ||= Mumukit::Login::Settings.new(login_methods)
  end

  def customized_login_methods?
    login_methods.size < Mumukit::Login::Settings.login_methods.size
  end

  private

  def ensure_consistent_public_login
    errors.add(:base, :consistent_public_login) if customized_login_methods? && public?
  end
end

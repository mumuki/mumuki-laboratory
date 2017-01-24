OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  Mumukit::Auth::Login.configure_omniauth! self
end

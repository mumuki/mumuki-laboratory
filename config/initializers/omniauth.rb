OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  Mumukit::Login.configure_omniauth! self
end

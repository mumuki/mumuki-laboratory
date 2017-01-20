OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  Mumukit::Auth.config.login_provider.set_auth_provider self
end

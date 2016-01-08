OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :auth0,
           Rails.configuration.auth0_client_id,
           Rails.configuration.auth0_client_secret,
           Rails.configuration.auth0_domain,
           callback_path: '/auth/auth0/callback'
end
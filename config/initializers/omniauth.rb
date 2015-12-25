OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :auth0,
           ENV['MUMUKI_AUTH0_CLIET_ID'],
           ENV['MUMUKI_AUTH0_CLIENT_SECRET'],
           ENV['MUMUKI_AUTH0_DOMAIN'],
           callback_path: '/auth/auth0/callback'
end
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['MUMUKI_GITHUB_CLIENT_ID'], ENV['MUMUKI_GITHUB_CLIENT_SECRET'], scope: 'user:email'
end


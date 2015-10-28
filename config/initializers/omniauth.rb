OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['MUMUKI_GITHUB_CLIENT_ID'], ENV['MUMUKI_GITHUB_CLIENT_SECRET'], scope: 'user:email'
  provider :facebook, ENV['MUMUKI_FACEBOOK_KEY'], ENV['MUMUKI_FACEBOOK_SECRET'], :image_size => 'large'
end

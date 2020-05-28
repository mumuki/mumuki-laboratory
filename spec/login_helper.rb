Mumukit::Login.configure do |config|
  config.auth0 = struct
  config.saml = struct

  config.mucookie_domain = '.localmumuki.io'
  config.mucookie_secret_key = 'abcde1213456123456'
  config.mucookie_secret_salt = 'mucookie test secret salt'
  config.mucookie_sign_salt = 'mucookie test sign salt'
end

OmniAuth.config.mock_auth[:developer] =
  OmniAuth::AuthHash.new provider: 'developer',
                         uid: 'johndoe@test.com',
                         credentials: {},
                         info: { first_name: 'John', last_name: 'Doe', name: 'John Doe', nickname: 'johndoe', image: 'user_shape.png' }

def set_current_user!(user)
  allow_any_instance_of(ApplicationController).to receive(:current_user_uid).and_return(user.uid)
end

def set_automatic_login!(test_mode)
  OmniAuth.config.test_mode = test_mode
end

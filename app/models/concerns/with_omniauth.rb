module WithOmniauth
  extend ActiveSupport::Concern

  module ClassMethods
    def omniauth(auth)
      where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
        extract_profile!(auth, user)
        user.save!
      end
    end

    def extract_profile!(auth, user)
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.nickname || auth.info.name
      user.email = auth.info.email
      user.image_url = auth.info.image
      user.token = auth.credentials.token
      user.expires_at = DateTime.now + 2.month
    end
  end
end

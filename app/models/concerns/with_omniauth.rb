module WithOmniauth
  extend ActiveSupport::Concern

  module ClassMethods
    def omniauth(auth)
      where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
        extract_profile!(auth, user)
        auth.credentials.expires_at.try do |expiration|
          user.expires_at = Time.at(expiration)
        end
        user.save!
      end
    end

    def extract_profile!(auth, user)
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.nickname
      user.email = auth.info.email
      user.image_url = auth.info.image
      user.token = auth.credentials.token
    end
  end
end

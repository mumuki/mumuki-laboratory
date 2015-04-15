module WithOmniauth
  extend ActiveSupport::Concern

  module ClassMethods
    def omniauth(auth)
      where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.nickname
        user.email = auth.info.email
        user.token = auth.credentials.token
        user.image_url = auth.image
        auth.credentials.expires_at.try do |expiration|
          user.expires_at = Time.at(expiration)
        end
        user.save!
      end
    end
  end
end

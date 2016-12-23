module WithOmniauth
  extend ActiveSupport::Concern

  module ClassMethods
    def omniauth(omniauth)
      auth = {
        provider: omniauth.provider,
        name: omniauth.info.nickname || omniauth.info.name,
        social_id: omniauth.uid,
        email: omniauth.info.email,
        uid: omniauth.info.email || omniauth.uid,
        image_url: omniauth.info.image
      }
      find_by_auth(auth).first_or_initialize.tap do |user|
        extract_profile!(auth, user)
        user.save!
      end
    end

    def extract_profile!(auth, user)
      user.assign_attributes(auth)
      user.create_remember_me_token!
    end

    def find_by_auth(auth)
      where(uid: auth[:uid])
    end
  end
end

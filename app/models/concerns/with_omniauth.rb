module WithOmniauth
  extend ActiveSupport::Concern

  module ClassMethods
    def omniauth(auth)
      find_by_auth(auth).first_or_initialize.tap do |user|
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
      user.create_remember_me_token!
    end

    def find_by_auth(auth)
      where('(provider = ? and uid = ?) or email = ?', auth.provider, auth.uid, auth.info.email)
    end
  end
end

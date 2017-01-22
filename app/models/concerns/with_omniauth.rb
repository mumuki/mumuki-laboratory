module WithOmniauth
  extend ActiveSupport::Concern

  module ClassMethods
    def omniauth(omniauth)
      profile = Mumukit::Login.normalized_omniauth_profile omniauth

      find_by_auth(profile).first_or_initialize.tap do |user|
        user.assign_attributes(profile.to_h)
        user.create_remember_me_token!
        user.save!
      end
    end


    def find_by_auth(auth)
      where(uid: auth.uid)
    end
  end
end

module WithProfile
  extend ActiveSupport::Concern

  module ClassMethods
    def for_profile(profile)
      #FIXME ensure index
      where(uid: profile.uid).first_or_initialize.tap do |user|
        user.assign_attributes(profile.to_h)
        user.create_remember_me_token!
        user.save!
      end
    end
  end
end

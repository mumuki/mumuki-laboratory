module WithProfile
  extend ActiveSupport::Concern

  module ClassMethods
    def for_profile(profile)
      where(uid: profile.uid).first_or_initialize.tap do |user|
        user.assign_attributes(profile.to_h.compact)
        user.save_and_notify_changes!
      end
    end
  end
end

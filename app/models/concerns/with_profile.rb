module WithProfile
  extend ActiveSupport::Concern

  module ClassMethods
    def for_profile(profile)
      where(uid: profile.uid).first_or_initialize.tap do |user|
        user.assign_attributes(profile.to_h.except(:name).compact)
        user.save_and_notify_changes!
      end
    end
  end

  def name
    self[:name] || "#{first_name} #{last_name}"
  end
end

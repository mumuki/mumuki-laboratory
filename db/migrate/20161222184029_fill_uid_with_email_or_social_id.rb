class FillUidWithEmailOrSocialId < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.update!(uid: (user.email.present?? user.email : user.social_id))
    end
  end

  def down
    User.update_all(uid: nil)
  end
end

class Atheneum::Command::UpdateUserMetadata
  def self.execute!(body)
    User.find_by(uid: body['social_id']).revoke!
  end
end

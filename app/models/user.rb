class User < ActiveRecord::Base
  has_many :submissions, foreign_key: :submitter_id
  has_many :exercises, foreign_key: :author_id
  has_many :guides, foreign_key: :author_id

  def self.omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.nickname
      user.email = auth.info.email
      user.token = auth.credentials.token
      auth.credentials.expires_at.try do |expiration|
        user.expires_at = Time.at(expiration)
      end
      user.save!
    end
  end
end

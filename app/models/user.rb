class User < ActiveRecord::Base
  has_many :submissions
  has_many :exercises

  def self.omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.token = auth.credentials.token
      auth.credentials.expires_at.try do |expiration|
        user.expires_at = Time.at(expiration)
      end
      user.save!
    end
  end
end
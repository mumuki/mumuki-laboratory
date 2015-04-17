module WithFollowers
  extend ActiveSupport::Concern
  included do
    has_many :relationships, foreign_key: :follower_id, dependent: :destroy
    has_many :following, through: :relationships, source: :followed
  end
  def follow(other_user)
    relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end

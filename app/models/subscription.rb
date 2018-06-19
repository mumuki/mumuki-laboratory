class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :discussion

  def unread!
    update! read: false
  end
end

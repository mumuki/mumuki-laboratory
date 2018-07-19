class Upvote < ApplicationRecord
  belongs_to :user
  belongs_to :discussion, counter_cache: true
end

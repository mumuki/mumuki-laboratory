class Progress < ActiveRecord::Base
  belongs_to :user
  belongs_to :item, polymorphic: true

  enum status: [:pending, :started, :done]
end

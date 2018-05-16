class Discussion < ApplicationRecord
  belongs_to :item, polymorphic: true
  has_many :messages
  belongs_to :initiator, class_name: 'User'

  validates_presence_of :title, :description

  def used_in?(organization)
    item.used_in?(organization).present?
  end

  def friendly
    title
  end

  def submit_message!(message, user)
    message.merge!(sender: user.uid)
    messages.create(message)
  end
end

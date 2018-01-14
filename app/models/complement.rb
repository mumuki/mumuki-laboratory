class Complement < ApplicationRecord
  include GuideContainer
  include FriendlyName

  validates_presence_of :book

  belongs_to :guide
  belongs_to :book

  include TerminalNavigation

  def used_in?(organization)
    organization.book == book
  end
end

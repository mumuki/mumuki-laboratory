class Chapter < ActiveRecord::Base
  include WithStats
  include WithNumber

  include FriendlyName

  include TopicContainer

  belongs_to :book
  belongs_to :topic

  include SiblingsNavigation
  include TerminalNavigation

  def used_in?(organization)
    organization.book == self.book
  end

  def pending_siblings_for(user)
    book.pending_chapters(user)
  end
end

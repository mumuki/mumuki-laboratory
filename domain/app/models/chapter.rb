class Chapter < ApplicationRecord
  include WithStats
  include WithNumber

  include FriendlyName

  include TopicContainer

  belongs_to :book, optional: true
  belongs_to :topic

  has_many :exercises, through: :topic

  include SiblingsNavigation
  include TerminalNavigation

  def used_in?(organization)
    organization.book == self.book
  end

  def pending_siblings_for(user)
    book.pending_chapters(user)
  end

  def index_usage!(organization = Organization.current)
    organization.index_usage_of! topic, self
    lessons.each { |lesson| lesson.index_usage! organization }
  end
end

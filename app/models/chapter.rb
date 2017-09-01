class Chapter < ActiveRecord::Base
  include WithStats
  include WithNumber

  include FriendlyName

  include TopicContainer

  belongs_to :book
  belongs_to :topic

  include SiblingsNavigation
  include ParentNavigation

  alias_method :unit, :navigable_parent

  def used_in?(organization)
    organization.first_book == self.book #FIXME, index chapters too
  end

  def structural_parent
    book
  end

  def pending_siblings_for(user)
    book.pending_chapters(user) # FIXME broken. Use progress
  end

  def index_usage_at!(organization)
    organization.index_usage_of! topic, self
    lessons.each { |lesson| lesson.index_usage_at! organization }
  end
end

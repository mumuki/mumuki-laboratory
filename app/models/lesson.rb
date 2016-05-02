class Lesson < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name, :description],
      associated_against: {
          language: [:name]
      }
  }

  include WithNumber
  include WithSearch
  include FriendlyName

  include GuideContainer

  belongs_to :topic
  belongs_to :guide

  include ParentNavigation, SiblingsNavigation

  def chapter
    navigable_parent #FIXME
  end

  def pending_siblings_for(user)
    topic.pending_lessons(user)
  end

  def structural_parent
    topic
  end
end

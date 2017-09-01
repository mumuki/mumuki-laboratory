class Lesson < ActiveRecord::Base
  include WithNumber

  include FriendlyName
  include GuideContainer

  validates_presence_of :topic

  belongs_to :topic
  belongs_to :guide

  include ParentNavigation
  include SiblingsNavigation

  alias_method :chapter, :navigable_parent

  def pending_siblings_for(user)
    topic.pending_lessons(user)
  end

  def structural_parent
    topic
  end
end

class Lesson < ActiveRecord::Base
  include WithNumber

  include FriendlyName

  include GuideContainer

  belongs_to :topic
  belongs_to :guide

  include ParentNavigation, SiblingsNavigation

  def pending_siblings_for(user)
    topic.pending_lessons(user)
  end

  def structural_parent
    topic
  end
end

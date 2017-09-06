class Lesson < GuideContainer
  include WithNumber

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

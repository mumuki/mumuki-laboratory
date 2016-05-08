class Lesson < ActiveRecord::Base
  include WithNumber
  include FriendlyName

  include GuideContainer

  belongs_to :topic
  belongs_to :guide

  include ParentNavigation, SiblingsNavigation

  alias_method :chapter, :navigable_parent

  def pending_siblings_for(user)
    topic.pending_lessons(user)
  end

  def structural_parent
    topic
  end

  def self.by_full_text(q)
    Guide.by_full_text(q).map(&:lesson).compact
  end
end

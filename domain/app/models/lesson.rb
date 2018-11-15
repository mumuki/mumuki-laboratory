class Lesson < ApplicationRecord
  include WithNumber
  include FriendlyName

  include GuideContainer

  belongs_to :topic
  belongs_to :guide

  include ParentNavigation, SiblingsNavigation

  alias_method :chapter, :navigable_parent

  def used_in?(organization)
    guide.usage_in_organization(organization) == self
  end

  def pending_siblings_for(user)
    topic.pending_lessons(user)
  end

  def structural_parent
    topic
  end
end

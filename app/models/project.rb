class Project < ActiveRecord::Base
  include WithNumber

  include FriendlyName
  include GuideContainer

  validates_presence_of :unit

  belongs_to :unit
  belongs_to :guide

  include ParentNavigation, SiblingsNavigation

  def pending_siblings_for(user)
    unit.pending_lessons(user)
  end

  def structural_parent
    unit
  end
end

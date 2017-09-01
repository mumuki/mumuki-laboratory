class Complement < ActiveRecord::Base


  include FriendlyName
  include GuideContainer

  validates_presence_of :unit

  belongs_to :unit
  belongs_to :guide

  include ParentNavigation

  def structural_parent
    unit
  end

end






class Complement < GuideContainer
  belongs_to :unit
  belongs_to :guide

  include ParentNavigation

  def structural_parent
    unit
  end

end






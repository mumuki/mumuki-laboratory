module GuideContainer
  extend ActiveSupport::Concern

  included do
    validates_presence_of :guide

    delegate :exercises, :name, to: :guide
  end

  def friendly
    defaulting_name { "#{navigable_parent.friendly}: #{name}" }
  end
end
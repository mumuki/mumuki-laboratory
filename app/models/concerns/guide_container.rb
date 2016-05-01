module GuideContainer
  extend ActiveSupport::Concern
  included do
    validates_presence_of :guide

    delegate :exercises, to: :guide
  end
end
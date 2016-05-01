module GuideContainer
  extend ActiveSupport::Concern
  included do
    validates_presence_of :guide

    delegate :exercises, :name, :friendly_name, to: :guide
  end
end
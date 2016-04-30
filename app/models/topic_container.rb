module TopicContainer
  extend ActiveSupport::Concern
  included do
    validates_presence_of :topic

    delegate :lessons, :pending_guides, :first_guide, :guides, :exercises, to: :topic
  end
end
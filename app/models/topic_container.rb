module TopicContainer
  extend ActiveSupport::Concern
  included do
    validates_presence_of :topic

    delegate :name,
             :description,
             :description_html,
             :long_description,
             :long_description_html,
             :rebuild!,
             :lessons,
             :pending_guides,
             :first_guide,
             :guides,
             :locale,
             :exercises, to: :topic
  end
end
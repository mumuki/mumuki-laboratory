module GuideContainer
  extend ActiveSupport::Concern

  included do
    validates_presence_of :guide

    delegate :name,
             :language,
             :search_tags,
             :exercises,
             :first_exercise,
             :next_exercise,
             :stats_for,
             :exercises_count, to: :guide
  end

  def index_usage!(organization = Organization.current)
    organization.index_usage_of! guide, self
  end

  def friendly
    defaulting_name { "#{navigable_parent.friendly}: #{name}" }
  end

  def validate_accessible_for!(user)
  end

  def timed?
    false
  end

  def start!(user)
  end
end

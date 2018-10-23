module GuideContainer
  extend ActiveSupport::Concern

  included do
    validates_presence_of :guide

    delegate :name,
             :slug,
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

  # Tells the number of remaning
  # attemps for a given assignment that belongs to this
  # container, or `nil`, if this container does not impose
  # any limit to the number of submissions
  def attempts_left_for(assignment)
    nil
  end

  # Tells if this guide container
  # imposes any kind of limit to the number of submission
  # to its assignments, which may depend on the exercise's type
  def limited_for?(exercise)
    false
  end

  def timed?
    false
  end

  def start!(user)
  end

  def resettable?
    true
  end
end

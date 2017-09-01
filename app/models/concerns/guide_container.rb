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

  def index_usage_at!(organization)
    organization.index_usage_of! guide, self
  end

  def access!(user)
  end

  def timed?
    false
  end

  def start!(user)
  end

  def used_in?(organization)
    guide.usage_in_organization(organization) == self
  end
end

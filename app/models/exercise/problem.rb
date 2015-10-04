class Problem < Exercise
  include WithExpectations,
          Solvable

  validates_presence_of :test

  extend FriendlyId
  friendly_id :generate_custom_slug, use: [:slugged, :finders]

  def self.model_name
    Exercise.model_name
  end

  def expectations
    super + guide_expectations
  end

  def guide_expectations
    if guide.present?
      guide.expectations
    else
      []
    end
  end
end

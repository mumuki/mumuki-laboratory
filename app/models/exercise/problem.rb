class Problem < Exercise
  include WithExpectations,
          Solvable

  validates_presence_of :test

  def self.model_name
    Exercise.model_name
  end

  def setup_query_assignment!(assignment)
  end

  def save_query_results!(assignment)
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

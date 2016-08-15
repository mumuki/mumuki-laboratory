class Problem < Exercise
  include WithExpectations,
          Solvable

  validate :ensure_evaluation_criteria

  def self.model_name
    Exercise.model_name
  end

  def setup_query_assignment!(assignment)
  end

  def save_query_results!(assignment)
  end

  def reset!
    super
    self.test = nil
    self.expectations = []
  end

  def expectations
    super + guide_expectations
  end

  def guide_expectations
    guide.expectations
  end

  def evaluation_criteria?
    manual_evaluation? || expectations.present? || test.present?
  end

  private

  def ensure_evaluation_criteria
    errors.add :base, :evaluation_criteria_required unless evaluation_criteria?
  end
end

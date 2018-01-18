class Kids < Exercise
  include WithExpectations,
          WithEditor,
          Solvable

  markdown_on :corollary

  validate :ensure_evaluation_criteria

  name_model_as Exercise

  def layout
    'input_kids'
  end

  def editor
    :custom
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

class Playground < Challenge
  validate :ensure_queriable_language

  name_model_as Exercise

  def setup_query_assignment!(assignment)
    assignment.running!
  end

  def save_query_results!(assignment)
    assignment.passed!
  end

  private

  def ensure_queriable_language
    errors.add(:base, :language_not_queriable) unless queriable?
  end

end

class Reading < Exercise
  include Confirmable

  name_model_as Exercise

  def layout
    :no_input
  end

  def queriable?
    false
  end

  def evaluation_class
    NoEvaluation
  end
end

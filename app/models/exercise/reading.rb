class Reading < Exercise
  include Confirmable

  name_model_as Exercise

  def layout
    :input_bottom
  end

  def queriable?
    false
  end

  def evaluation_class
    NoEvaluation
  end
end

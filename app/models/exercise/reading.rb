class Reading < Exercise
  include Confirmable

  name_model_as Exercise

  def evaluation_class
    NoEvaluation
  end
end

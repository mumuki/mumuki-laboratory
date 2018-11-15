class Reading < Exercise
  include Confirmable

  name_model_as Exercise

  def layout
    :input_bottom
  end

  def input_kids?
    false
  end

  def queriable?
    false
  end
end

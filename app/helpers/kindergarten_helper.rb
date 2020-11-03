module KindergartenHelper
  def kindergarten_full_workspace?(exercise)
    !exercise.initial_state && !exercise.final_state
  end
end

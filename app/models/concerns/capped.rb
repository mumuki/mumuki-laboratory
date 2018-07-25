class Capped
  def initialize(attempts_left)
    @attempts_left = attempts_left
  end

  def submit_solution!(exercise, user, solution)
    return unless @attempts_left > 0

    exercise.submit_solution!(user, solution)
  end
end

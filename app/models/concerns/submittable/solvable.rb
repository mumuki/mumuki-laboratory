module Solvable
  def submit_solution!(user, attributes={})
    submit! user, Solution.new(attributes)
    assignment_for user
  end
end

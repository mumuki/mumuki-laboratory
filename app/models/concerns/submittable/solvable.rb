module Solvable
  def submit_solution(user, solution_attributes={})
    solution = Solution.new(solution_attributes)
    assignment = transaction do
      assignment_with(user, solution: solution.content).tap { |it| it.submit! }
    end
    solution.assignment = assignment
    solution
  end
end
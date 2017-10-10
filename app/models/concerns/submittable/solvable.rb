module Solvable
  def submit_solution!(user, attributes={})
    assignment, _ = find_assignment_and_submit! user, Solution.new(content: attributes[:content]&.normalize_whitespaces)
    assignment
  end

  def run_tests!(params)
    language.run_tests!(
      params.merge(
        test: test,
        extra: extra,
        locale: locale,
        expectations: expectations))
  end
end

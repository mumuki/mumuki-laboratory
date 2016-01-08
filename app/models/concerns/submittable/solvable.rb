module Solvable
  def submit_solution!(user, attributes={})
    submit! user, Solution.new(attributes)
    assignment_for user
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

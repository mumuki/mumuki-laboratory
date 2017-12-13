module Solvable
  def submit_solution!(user, attributes={})
    content = attributes[:content]
    attributes[:content] = join_files(content) if content.is_a? Hash
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

  private

  def join_files(files)
    language
      .directives_sections
      .join files
  end
end

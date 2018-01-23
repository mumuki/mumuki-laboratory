module Solvable
  def submit_solution!(user, attributes={})
    assignment, _ = find_assignment_and_submit! user, attributes[:content].to_mumuki_solution(language, attributes[:content_metadata])
    assignment
  end

  def run_tests!(params)
    language.run_tests!(
      params.merge(
        test: test,
        locale: locale,
        expectations: expectations))
  end
end

class NilClass
  def to_mumuki_solution(language, _)
    Solution.new
  end
end

class String
  def to_mumuki_solution(language, content_metadata)
    Solution.new content: normalize_whitespaces, content_metadata: content_metadata
  end
end

class Hash
  def to_mumuki_solution(language, content_metadata)
    language
      .directives_sections
      .join(self)
      .to_mumuki_solution(language, content_metadata)
  end
end

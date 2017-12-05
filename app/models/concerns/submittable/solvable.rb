module Solvable
  def submit_solution!(user, attributes={})
    content = attributes[:content]
    attributes[:content] = serialize(content) if content.is_a? Hash
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

  def serialize(content)
    comment_type = Mumukit::Directives::CommentType.parse(language.comment_type)
    file_declarations, file_references = content.map{|filename, content| method_name(comment_type, content, filename)}.transpose
    "#{file_declarations.join "\n" }\n#{wrapWith 'content', file_references.join("\n"), comment_type}"
  end

  def method_name(comment_type, content, filename)
    [wrapWith(filename, content, comment_type), (comment_type.comment "...#{filename}...")]
  end

  def wrapWith(tag, text, comment_type)
    "#{comment_type.comment "<#{tag}#"}#{text}#{comment_type.comment "##{tag}>"}"
  end
end

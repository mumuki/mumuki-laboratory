require 'mumukit/directives'

class Mumukit::Directives::Sections < Mumukit::Directives::Directive
  def build(section, content)
    "#{comment_type.comment "<#{section}#"}#{content}#{comment_type.comment "##{section}>"}"
  end

  def join(sections)
    file_declarations, file_references = sections.map do |section, content|
      [build(section, content), interpolate(section)]
    end.transpose
    "#{file_declarations.join "\n"}\n#{build 'content', file_references.join("\n")}"
  end

  def interpolate(section)
    comment_type.comment("...#{section}...")
  end
end

require 'mumukit/directives'

class Mumukit::Directives::Sections < Mumukit::Directives::Directive
  # TODO Move this behaviour to gem
  def join(sections)
    file_declarations, file_references = sections.map do |section, content|
      [build(section, content), interpolate(section)]
    end.transpose

    file_declarations.join "\n"
  end

  def build(section, content)
    "#{comment_type.comment "<#{section}#"}#{content}#{comment_type.comment "##{section}>"}"
  end

  def interpolate(section)
    comment_type.comment("...#{section}...")
  end
end

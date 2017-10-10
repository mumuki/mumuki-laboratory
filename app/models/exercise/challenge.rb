class Challenge < Exercise
  include WithLayout

  markdown_on :hint, :extra_preview

  def extra_preview
    Mumukit::ContentType::Markdown.highlighted_code(language.name, extra)
  end

  def reset!
    super
    self.layout = self.class.default_layout
  end

  def extra
    extra_code = [guide.extra, self[:extra]].compact.join("\n")
    if extra_code.empty? or extra_code.end_with? "\n"
      extra_code
    else
      "#{extra_code}\n"
    end
  end

  private

  def defaults
    super
    self.layout = self.class.default_layout
  end
end

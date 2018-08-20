class Challenge < Exercise
  include WithLayout

  markdown_on :hint

  def reset!
    super
    self.layout = self.class.default_layout
  end

  def extra(*)
    [guide.extra, super]
      .compact
      .join("\n")
      .strip
      .ensure_newline
  end

  private

  def defaults
    super
    self.layout = self.class.default_layout
  end
end

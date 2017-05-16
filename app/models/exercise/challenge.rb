class Challenge < Exercise
  include WithLayout,
          Queriable

  markdown_on :hint,
              :extra_preview

  delegate :stateful_console?, to: :language

  def extra_preview
    Mumukit::ContentType::Markdown.highlighted_code(language.name, extra)
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

  def evaluation_class
    if manual_evaluation?
      manual_evaluation_class
    else
      automated_evaluation_class
    end
  end

  def manual_evaluation_class
    ManualEvaluation
  end

  def automated_evaluation_class
    AutomatedEvaluation
  end

  def defaults
    super
    self.layout = self.class.default_layout
  end
end

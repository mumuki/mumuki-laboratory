class Challenge < Exercise
  include WithLanguage,
          WithLayout,
          Queriable

  validates_presence_of :language

  markdown_on :hint

  delegate :stateful_console?, to: :language

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

  private

  def defaults
    super
    self.layout = self.class.default_layout
  end
end

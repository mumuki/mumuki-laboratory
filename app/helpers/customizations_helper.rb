module CustomizationsHelper

  delegate :default_content,
           :description_html,
           :description_task_html,
           :description_context_html,
           :hint_html,
           :extra,
           :test, to: :customizable, prefix: :customized

  private

  def customizable
    @assignment || @exercise
  end
end

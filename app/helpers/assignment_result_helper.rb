module AssignmentResultHelper
  def t_expectation(expectation)
    raw Mumukit::Inspection::Expectation.parse(expectation).translate
  end

  def render_feedback?(assignment)
    StatusRenderingVerbosity.render_feedback?(assignment.feedback)
  end

  def t_assignment_status(assignment)
    t assignment_status assignment
  end

  def assignment_status(assignment)
    if assignment.exercise.hidden?
      :hidden_done
    elsif assignment.exercise.choices?
      assignment.passed? ? :correct_answer : :wrong_answer
    else
      assignment.status
    end
  end

  def render_test_results(assignment)
    if assignment.test_results.present?
      render partial: 'layouts/test_results', locals: { assignment: assignment }
    else
      render partial: 'layouts/result', locals: { assignment: assignment }
    end
  end

  def solution_download_link(assignment)
    link_to fa_icon(:download, text: t(:download)),
            solution_octet_data(assignment),
            download: solution_filename(assignment) if assignment.exercise.upload?
  end

  def community_link
    Organization.current.community_link
  end

  def community_link?
    community_link.present?
  end

  def render_community_link
    if community_link?
      link_to fa_icon(:facebook, text: I18n.t(:ask_community), class: 'fa-fw'), community_link, target: '_blank'
    end
  end

  def manual_evaluation_comment(assignment)
    if assignment.manual_evaluation_comment?
      Mumukit::ContentType::Markdown.to_html assignment.manual_evaluation_comment
    end
  end

  def showable_tips_html(assignment)
    Mumukit::ContentType::Markdown.to_html assignment.showable_tips.map { |tip| "* #{tip}" }.join "\n"
  end

  private

  def solution_octet_data(assignment)
    "data:application/octet-stream,#{URI.encode assignment.solution}"
  end

  def solution_filename(assignment)
    "solution.#{assignment.extension}"
  end
end

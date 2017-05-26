module AssignmentResultHelper
  def t_expectation(expectation)
    raw Mumukit::Inspection::I18n.t expectation
  end

  def render_feedback?(assignment)
    StatusRenderingVerbosity.render_feedback?(assignment.feedback)
  end

  def render_test_results(assignment)
    if assignment.test_results.present?
      render partial: 'layouts/test_results', locals: {
        visible_success_output: assignment.visible_success_output?,
        test_results: assignment.test_results,
        output_content_type: assignment.output_content_type}
    else
      assignment.result_html
    end
  end

  def solution_download_link(assignment)
    link_to fa_icon(:download, text: t(:download)),
            solution_octet_data(assignment),
            download: solution_filename(assignment),
            class: 'pull-right'
  end

  def community_link
    Organization.current.community_link
  end

  def community_link?
    community_link.present?
  end

  def render_community_link
    link_to fa_icon(:facebook, text: I18n.t(:access_community), class: 'fa-fw'), community_link, target: '_blank' if community_link?
  end

  private

  def solution_octet_data(assignment)
    "data:application/octet-stream,#{URI.encode assignment.solution}"
  end

  def solution_filename(assignment)
    "solution.#{assignment.extension}"
  end
end

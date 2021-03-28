module AssignmentResultHelper
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
      link_to fa_icon('facebook-f', type: :brand, text: I18n.t(:ask_community), class: 'fa-fw'),
              community_link, target: '_blank', class: 'dropdown-item'
    end
  end

  def report_bug_link(assignment, organization=Organization.current)
    if organization.report_issue_enabled?
      mail_to organization.contact_email,
        fa_icon(:bug, text: t(:notify_problem_with_exercise), class: 'fa-fw'),
        subject: t(:problem_with_exercise, title: @exercise.name),
        body: assignment_help_email_body(assignment),
        class: 'dropdown-item'
    end
  end

  def manual_evaluation_comment(assignment)
    if assignment.manual_evaluation_comment?
      Mumukit::ContentType::Markdown.to_html assignment.manual_evaluation_comment
    end
  end

  private

  def solution_octet_data(assignment)
    "data:application/octet-stream,#{URI.encode assignment.solution}"
  end

  def solution_filename(assignment)
    "solution.#{assignment.extension}"
  end
end

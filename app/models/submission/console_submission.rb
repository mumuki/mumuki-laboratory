class ConsoleSubmission < Submission
  def try_evaluate_exercise!(assignment)
    format_result evaluate_exercise!(assignment)
  end

  def format_result(results)
    results[:result] = I18n.t(:try_again) if results[:status] == :errored
    results[:status] = results[:status].to_mumuki_status
    results
  end
end

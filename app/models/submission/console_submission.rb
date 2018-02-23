module ConsoleSubmission
  def format_result(results)
    results[:result] = I18n.t(:try_again) if results[:status] == :errored
    results[:status] = results[:status].to_mumuki_status
    results
  end
end

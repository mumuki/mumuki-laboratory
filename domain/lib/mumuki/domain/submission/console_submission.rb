class Mumuki::Domain::Submission::ConsoleSubmission < Mumuki::Domain::Submission::Base
  required :try_evaluate_query!

  def try_evaluate!(assignment)
    format_query_result! try_evaluate_query!(assignment)
  end

  def format_query_result!(results)
    results[:result] = I18n.t(:try_again) if results[:status].aborted?
    results[:status] = results[:status].to_submission_status
    results
  end
end

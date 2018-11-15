module Triable
  def submit_try!(user, attributes={})
    find_assignment_and_submit! user, Mumuki::Domain::Submission::Try.new(attributes)
  end

  def run_try!(params)
    language.run_try! params.merge(locale: locale, goal: goal)
  end
end

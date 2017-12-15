module Triable
  def submit_try!(user, attributes={})
    find_assignment_and_submit! user, Try.new(attributes)
  end

  def run_try!(user, params)
    language.run_try! params.merge(extra: extra_for(user), locale: locale, goal: goal)
  end
end

module Triable
  def submit_try!(user, attributes={})
    submit! user, Try.new(attributes)
  end

  def run_try!(params)
    language.run_try! params.merge(extra: extra, locale: locale, goal: goal)
  end
end

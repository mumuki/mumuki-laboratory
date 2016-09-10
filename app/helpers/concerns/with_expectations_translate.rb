require 'mumukit/inspection'

module WithExpectationsTranslate
  def t_expectation(expectation)
    raw Mumukit::Inspection::I18n.t expectation
  end
end

require 'mumukit/inspection'

module ExpectationsHelper
  def t_expectation(expectation)
    raw Mumukit::Inspection::I18n.t expectation
  end
end

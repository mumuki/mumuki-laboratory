class Mumukit::Inspection::NegatedInspection
  def must
    'must_not'
  end
end

class Mumukit::Inspection::PositiveInspection
  def must
    'must'
  end
end

module WithExpectationsTranslate

  def t_expectation_result(binding, inspection)
    inspection = Mumukit::Inspection.parse inspection
    raw t "expectation_#{inspection.type}", binding: "<strong>#{binding}</strong>", target: "<strong>#{inspection.target}</strong>", must: t_must(inspection)
  end

  def t_must(parsed)
    t("expectation_#{parsed.must}")
  end
end

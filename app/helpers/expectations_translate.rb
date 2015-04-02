module ExpectationsTranslate

  def t_expectation_result(binding, inspection)
    parsed = parse_inspection inspection
    t "expectation_#{parsed[:inspection]}", binding: binding, target: parsed[:target], must: t_type(parsed)
  end

  def t_type(parsed)
    t("expectation_#{parsed[:type]}")
  end

  def parse_inspection(inspection)
    target_match = inspection.match /^(.*HasUsage):(.*)$/
    if target_match
      {target: target_match[2]}.merge(parse_type(target_match[1]))
    else
      parse_type(inspection)
    end
  end

  def parse_type(inspection)
    not_match = inspection.match /^Not:(.*)$/
    if not_match
      {type: 'must_not', inspection: not_match[1]}
    else
      {type: 'must', inspection: inspection}
    end
  end
end

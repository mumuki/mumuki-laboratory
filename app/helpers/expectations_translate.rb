class Inspection
  class << self
    def parse(s)
      not_match = s.match /^Not:(.*)$/
      if not_match
        NegatedInspection.new(parse_base_inspection(not_match[1]))
      else
        parse_base_inspection(s)
      end
    end

    private

    def parse_base_inspection(s)
      target_match = s.match /^(.*HasUsage):(.*)$/
      if target_match
        TargetedInspection.new(target_match[1], target_match[2])
      else
        PlainInspection.new(s)
      end
    end
  end
end

class PositiveInspection < Inspection
  attr_accessor :type

  def negated?
    false
  end
end

class PlainInspection < PositiveInspection
  def initialize(type)
    @type = type
  end

  def target
    nil
  end
end

class TargetedInspection < PositiveInspection
  attr_accessor :target
  def initialize(type, target)
    @type = type
    @target = target
  end
end

class NegatedInspection < Inspection
  def initialize(inspection)
    @inspection = inspection
  end

  def negated?
    true
  end

  def target
    @inspection.target
  end

  def type
    @inspection.type
  end
end

class NegatedInspection
  def must
    'must_not'
  end
end

class PositiveInspection
  def must
    'must'
  end
end

class Inspection
  def to_h
    {must: must, type: type, target: target}
  end
end

module ExpectationsTranslate

  def t_expectation_result(binding, inspection)
    inspection = Inspection.parse inspection
    t "expectation_#{inspection.type}", binding: binding, target: inspection.target, must: t_must(inspection)
  end

  def t_must(parsed)
    t("expectation_#{parsed.must}")
  end
end

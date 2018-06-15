class Module
  def interpolations_on(*selectors, with:)
    selectors.each { |selector| _interpolate selector, with }
  end

  private

  def _interpolate(selector, interpolations_selector)
    define_method(selector) do |*args|
      language.interpolate super(*args), send(interpolations_selector).transform_values { |v| v.get(seed) }
    end
  end
end

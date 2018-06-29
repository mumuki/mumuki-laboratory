module WithRandomizations
  extend ActiveSupport::Concern

  included do
    include InstanceMethods
    extend ClassMethods
  end

  module InstanceMethods
    def seed
      @seed || 0
    end

    def seed_with!(seed)
      @seed = seed
    end
  end

  module ClassMethods
    def interpolations_on(*selectors, with:)
      selectors.each { |selector| _interpolate selector, with }
    end

    private

    def _interpolate(selector, interpolations_selector)
      define_method(selector) do |*args|
        return unless super(*args)
        interpolations = Mumukit::Randomizer.parse(send(interpolations_selector)).with_seed(seed)
        interpolations.inject(super(*args)) { |result, (replacee, replacer)| result.gsub "$#{replacee}", replacer }
      end
    end
  end
end

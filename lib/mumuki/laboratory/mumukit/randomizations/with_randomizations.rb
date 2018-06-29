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
    def randomize(*selectors, with:)
      selectors.each { |selector| randomize_field selector, with }
    end

    private

    def randomize_field(selector, randomizations_selector)
      define_method(selector) do |*args|
        return unless super(*args)
        interpolations = Mumukit::Randomizer.parse(send(randomizations_selector)).with_seed(seed)
        interpolations.inject(super(*args)) { |result, (replacee, replacer)| result.gsub "$#{replacee}", replacer }
      end
    end
  end
end

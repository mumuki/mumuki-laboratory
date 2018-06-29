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
    def randomize(*selectors)
      selectors.each { |selector| randomize_field selector }
    end

    private

    def randomize_field(selector)
      define_method(selector) do |*args|
        return unless super(*args)
        interpolations = Mumukit::Randomizer.parse(randomizations).with_seed(seed)
        interpolations.inject(super(*args)) { |result, (replacee, replacer)| result.gsub "$#{replacee}", replacer }
      end
    end
  end
end

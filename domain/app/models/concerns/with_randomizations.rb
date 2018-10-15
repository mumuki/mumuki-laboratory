module WithRandomizations
  extend ActiveSupport::Concern

  included do
    serialize :randomizations, Hash
  end

  def seed
    @seed || 0
  end

  def seed_with!(seed)
    @seed = seed
  end

  def randomizer
    @randomizer ||= Mumukit::Randomizer.parse(randomizations)
  end

  module ClassMethods
    def randomize(*selectors)
      selectors.each { |selector| randomize_field selector }
    end

    private

    def randomize_field(selector)
      define_method(selector) do |*args|
        return unless super(*args)
        randomizer.randomize!(super(*args), seed)
      end
    end
  end
end

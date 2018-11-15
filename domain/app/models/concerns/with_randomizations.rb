module WithRandomizations
  extend ActiveSupport::Concern

  included do
    serialize :randomizations, Hash
    validate :ensure_randomizations_format
  end

  def seed
    @seed || 0
  end

  def seed_with!(seed)
    @seed = seed
  end

  def randomizer
    #TODO remove this hack after removing seed state from here
    @randomizer ||= (Mumukit::Randomizer.parse(randomizations) rescue Mumukit::Randomizer.new([]))
  end

  private

  def ensure_randomizations_format
    errors.add :randomizations,
               :invalid_format unless Mumukit::Randomizer.valid? randomizations.to_h
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

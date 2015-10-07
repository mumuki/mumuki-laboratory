module WithSlug
  extend ActiveSupport::Concern

  included do
    make_slugged(self)
  end

  def slugged_name
    with_parent_name { "#{parent.name} - #{position}. #{name}" }
  end

  module ClassMethods
    def inherited(subclass)
      super
      make_slugged(subclass)
    end

    def make_slugged(clazz)
      clazz.class_eval do
        extend FriendlyId
        friendly_id :slugged_name, use: [:slugged, :finders] rescue nil
      end
    end
  end
end

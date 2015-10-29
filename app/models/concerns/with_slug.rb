module WithSlug
  extend ActiveSupport::Concern

  included do
    make_slugged(self)
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

        def should_generate_new_friendly_id?
          slug.blank? || name_changed?
        end
      end
    end
  end
end

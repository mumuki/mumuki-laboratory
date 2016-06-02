module WithMetadata
  extend ActiveSupport::Concern

  included do
    serialize :metadata, Mumukit::Auth::Metadata

    validates_presence_of :metadata

    delegate :student?, :admin?, to: :metadata

    def teacher?(slug) ## BIG FIX ME
      metadata.permissions('classroom').present?
    end
  end

end

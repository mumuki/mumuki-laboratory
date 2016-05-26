module WithMetadata
  extend ActiveSupport::Concern

  included do
    serialize :metadata, Mumukit::Auth::Metadata

    validates_presence_of :metadata

    delegate :student?, :teacher?, :admin?, to: :metadata
  end
end
module WithGuides
  extend ActiveSupport::Concern

  included do
    has_many :guides, -> { order(:position) }
  end

  def first_guide
    guides.first
  end
end


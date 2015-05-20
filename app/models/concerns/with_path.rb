module WithPath
  extend ActiveSupport::Concern

  included do
    belongs_to :path
    validates_presence_of :position, if: :path
  end

  def next_guides
   path ? path.guides.where('guides.position > :position', 'guides.position asc') : []
  end
end

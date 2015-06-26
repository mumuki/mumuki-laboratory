module WithPath
  extend ActiveSupport::Concern

  included do
    include WithSiblings

    belongs_to :path
  end

  def next_guides
   path ? siblings.where('guides.position > :position', position: position).order('guides.position asc') : []
  end


  def siblings
    path.guides
  end

  def parent
    path
  end
end

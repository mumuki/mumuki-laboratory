module WithPath
  extend ActiveSupport::Concern

  included do
    belongs_to :path
    validates_presence_of :position, if: :path
  end

  def next_guides
   path ? path.guides.where('guides.position > :position', position: position).order('guides.position asc') : []
  end

  def next
    path.guides.where(position: position + 1).first if path #FIXME duplicated in WithGuide
  end

  def previous
    path.guides.where(position: position - 1).first if path
  end
end

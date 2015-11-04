module WithPath
  extend ActiveSupport::Concern

  included do
    include WithSiblings

    has_one :path_rule
    has_one :path, through: :path_rule
  end

  def positionate!(path, position)
    self.path_rule = PathRule.new path: path, position: position, guide: self
    self.path = path
    self.path_rule
  end

  def siblings_for(user)
    path.pending_guides(user)
  end

  def siblings
    path.guides
  end

  def parent
    path
  end
end

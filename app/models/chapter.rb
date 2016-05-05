class Chapter < ActiveRecord::Base
  include WithStats
  include FriendlyName
  include TopicContainer

  belongs_to :book
  belongs_to :topic

  include SiblingsNavigation, ChildrenNavigation

  default_scope -> { order(:number) }

  def friendly
    name
  end

end

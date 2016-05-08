class Chapter < ActiveRecord::Base
  include WithStats
  include WithNumber

  include FriendlyName

  include TopicContainer

  belongs_to :book
  belongs_to :topic

  include ParentNavigation, SiblingsNavigation

  def pending_siblings_for(user)
    book.pending_chapters(user)
  end

  def structural_parent
    book
  end

  def friendly
    name
  end

end

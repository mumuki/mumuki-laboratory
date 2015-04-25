module WithAuthor
  extend ActiveSupport::Concern
  included do
    belongs_to :author, class_name: 'User'
  end
  def authored_by?(user)
    user == author || collaborator?(user)
  end
end

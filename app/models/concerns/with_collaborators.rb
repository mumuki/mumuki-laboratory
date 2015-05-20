module WithCollaborators
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :collaborators, class_name: 'User', join_table: 'collaborators'
  end

  def update_collaborators!
    self.collaborators = user_resources_to_users author.collaborators(self)
    save!
  end

  def collaborator?(user)
    collaborators.include? user
  end
end

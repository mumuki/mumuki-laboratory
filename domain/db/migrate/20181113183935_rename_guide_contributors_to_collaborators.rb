class RenameGuideContributorsToCollaborators < ActiveRecord::Migration[5.1]
  def change
    rename_column :guides, :contributors, :collaborators
  end
end

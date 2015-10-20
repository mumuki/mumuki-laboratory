class RemoveGuideGitInformation < ActiveRecord::Migration
  def change
    remove_column :guides, :original_id_format
    remove_column :guides, :github_repository
    add_column :guides, :url, :string, default: '', null: false
  end
end

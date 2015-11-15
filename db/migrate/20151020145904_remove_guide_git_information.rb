class RemoveGuideGitInformation < ActiveRecord::Migration
  def change
    remove_column :guides, :original_id_format, :string
    remove_column :guides, :github_repository, :string
    add_column :guides, :url, :string, default: '', null: false
  end
end

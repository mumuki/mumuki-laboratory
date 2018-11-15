class RemoveGuideGitInformation < ActiveRecord::Migration[4.2]
  def change
    remove_column :guides, :original_id_format, :string
    remove_column :guides, :github_repository, :string
    add_column :guides, :url, :string, default: '', null: false
  end
end

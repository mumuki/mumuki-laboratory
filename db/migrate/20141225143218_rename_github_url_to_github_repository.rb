class RenameGithubUrlToGithubRepository < ActiveRecord::Migration[4.2]
  def change
    rename_column :guides, :github_url, :github_repository
  end
end

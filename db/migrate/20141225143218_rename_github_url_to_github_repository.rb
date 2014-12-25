class RenameGithubUrlToGithubRepository < ActiveRecord::Migration
  def change
    rename_column :guides, :github_url, :github_repository
  end
end

class ChangeLanguageIconUrlIntoDeviconId < ActiveRecord::Migration
  def change
    rename_column :languages, :image_url, :devicon
  end
end

class ChangeLanguageIconUrlIntoDeviconId < ActiveRecord::Migration[4.2]
  def change
    rename_column :languages, :image_url, :devicon
  end
end

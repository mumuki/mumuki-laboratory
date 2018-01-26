class RemoveDeviconColumnFromLanguage < ActiveRecord::Migration[4.2]
  def change
    remove_column :languages, :devicon
  end
end

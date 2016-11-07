class RemoveDeviconColumnFromLanguage < ActiveRecord::Migration
  def change
    remove_column :languages, :devicon
  end
end

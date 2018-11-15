class AddUniquesToLanguages < ActiveRecord::Migration[4.2]
  def change
    add_index :languages, :name, unique: true
    add_index :languages, :extension, unique: true
  end
end

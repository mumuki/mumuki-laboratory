class AddUniquesToLanguages < ActiveRecord::Migration
  def change
    add_index :languages, :name, unique: true
    add_index :languages, :extension, unique: true
  end
end

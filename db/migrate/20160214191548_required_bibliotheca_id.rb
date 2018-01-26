class RequiredBibliothecaId < ActiveRecord::Migration[4.2]
  def change
    change_column :exercises, :bibliotheca_id, :integer, null: false
  end
end

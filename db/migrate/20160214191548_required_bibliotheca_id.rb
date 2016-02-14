class RequiredBibliothecaId < ActiveRecord::Migration
  def change
    change_column :exercises, :bibliotheca_id, :integer, null: false
  end
end

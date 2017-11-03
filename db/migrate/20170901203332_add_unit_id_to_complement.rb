class AddUnitIdToComplement < ActiveRecord::Migration
  def change
    add_reference :complements, :unit, index: true
    remove_column :complements, :book_id
    remove_column :organizations, :book_id
  end
end

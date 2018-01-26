class CreateImports < ActiveRecord::Migration[4.2]
  def change
    create_table :imports do |t|
      t.references :guide

      t.timestamps
    end
  end
end

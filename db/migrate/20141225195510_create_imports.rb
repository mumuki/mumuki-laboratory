class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.references :guide

      t.timestamps
    end
  end
end

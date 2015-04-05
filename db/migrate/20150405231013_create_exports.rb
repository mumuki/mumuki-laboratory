class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.references :guide, index: true

      t.timestamps
    end
  end
end

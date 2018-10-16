class CreateExports < ActiveRecord::Migration[4.2]
  def change
    create_table :exports do |t|
      t.references :guide, index: true

      t.timestamps
    end
  end
end

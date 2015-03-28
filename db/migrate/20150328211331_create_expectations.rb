class CreateExpectations < ActiveRecord::Migration
  def change
    create_table :expectations do |t|
      t.references :exercise
      t.string :binding
      t.string :inspection

      t.timestamps
    end
  end
end

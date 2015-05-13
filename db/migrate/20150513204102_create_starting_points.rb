class CreateStartingPoints < ActiveRecord::Migration
  def change
    create_table :starting_points do |t|
      t.references :category, index: true
      t.references :language, index: true
      t.references :guide, index: true

      t.timestamps
    end
  end
end

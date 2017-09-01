class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer  :number, default: 0, null: false
      t.references :unit, index: true
      t.references :guide, index: true

      t.timestamps
    end
  end
end

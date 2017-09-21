class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.integer :status, default: 0
      t.references :user, index: true
      t.references :item, polymorphic: true, index: true
      t.timestamps
    end
  end
end



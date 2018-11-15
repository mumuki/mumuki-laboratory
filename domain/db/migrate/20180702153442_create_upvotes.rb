class CreateUpvotes < ActiveRecord::Migration[5.1]
  def change
    create_table :upvotes do |t|
      t.references :user, index: true
      t.references :discussion, index: true
    end
  end
end

class RemoveExpectationsRelation < ActiveRecord::Migration[4.2]
  def change
    drop_table :expectations
  end
end

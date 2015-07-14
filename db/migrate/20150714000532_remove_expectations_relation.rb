class RemoveExpectationsRelation < ActiveRecord::Migration
  def change
    drop_table :expectations
  end
end

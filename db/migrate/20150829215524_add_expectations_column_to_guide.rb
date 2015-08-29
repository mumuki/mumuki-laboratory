class AddExpectationsColumnToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :expectations, :text
  end
end

class AddExpectationsColumnToGuide < ActiveRecord::Migration[4.2]
  def change
    add_column :guides, :expectations, :text
  end
end

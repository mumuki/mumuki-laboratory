class AddSubmissionsCountToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :submissions_count, :integer, default: 0, null: false
  end
end

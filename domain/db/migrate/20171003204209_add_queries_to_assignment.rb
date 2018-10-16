class AddQueriesToAssignment < ActiveRecord::Migration[4.2]
  def change
    add_column :assignments, :queries, :string, array: true, default: []
    add_column :assignments, :query_results, :text
  end
end

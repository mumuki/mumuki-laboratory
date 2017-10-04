class AddQueriesToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :queries, :string, array: true, default: []
    add_column :assignments, :query_results, :text, default: '[]'
  end
end

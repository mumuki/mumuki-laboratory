class AddInlineErrorsToAssignments < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :inline_errors, :text
  end
end

class AddSubmissionIdToSolution < ActiveRecord::Migration[4.2]
  def change
    add_column :solutions, :submission_id, :string
  end
end

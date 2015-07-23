class AddSubmissionIdToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :submission_id, :string
  end
end

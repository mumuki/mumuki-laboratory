class AddResultToSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :submissions, :result, :text
  end
end

class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text :content
      t.references :exercise, index: true
      t.integer :status, default: 0
      t.text :result
      t.references :submitter, index: true
      t.text :expectation_results
      t.text :feedback
      t.text :test_results

      t.timestamps
    end
  end
end

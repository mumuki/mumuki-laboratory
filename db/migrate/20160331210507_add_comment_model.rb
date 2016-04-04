class AddCommentModel < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :exercise_id
      t.integer :submission_id
      t.string :type
      t.string :content
      t.string :author
      t.datetime :date
      t.timestamps
    end
  end
end

class AddUserStartDataInExam < ActiveRecord::Migration[4.2]
  def change
    add_column :exam_authorizations, :started, :boolean, default: false
    add_column :exam_authorizations, :started_at, :datetime
  end
end

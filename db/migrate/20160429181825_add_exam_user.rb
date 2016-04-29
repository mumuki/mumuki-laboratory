class AddExamUser < ActiveRecord::Migration
  def change
    create_table :exams_users, id: false do |t|
      t.belongs_to :exam, index: true
      t.belongs_to :user, index: true
    end
  end
end

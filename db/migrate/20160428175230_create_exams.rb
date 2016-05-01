class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.references :organization, index: true
      t.references :guide, index: true

      t.timestamps
    end
  end
end

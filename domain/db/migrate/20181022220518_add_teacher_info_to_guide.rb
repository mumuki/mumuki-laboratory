class AddTeacherInfoToGuide < ActiveRecord::Migration[5.1]
  def change
    add_column :guides, :teacher_info, :text
    add_column :exercises, :teacher_info, :text
  end
end

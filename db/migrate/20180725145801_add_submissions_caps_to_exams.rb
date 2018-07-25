class AddSubmissionsCapsToExams < ActiveRecord::Migration[5.1]
  def change
    add_column :exams, :max_problem_submissions, :integer, default: 5
    add_column :exams, :max_choice_submissions, :integer, default: 1
  end
end

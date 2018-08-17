class AddSubmissionsCapsToExams < ActiveRecord::Migration[5.1]
  def change
    add_column :exams, :max_problem_submissions, :integer
    add_column :exams, :max_choice_submissions, :integer
  end
end

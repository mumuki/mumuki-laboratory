class AddFeedbackToLanguage < ActiveRecord::Migration[5.1]
  def change
    add_column :languages, :feedback, :boolean
  end
end

class AddLocaleToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :locale, :string, index: true, default: 'en'
  end
end

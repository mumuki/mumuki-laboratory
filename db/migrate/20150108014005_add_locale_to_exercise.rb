class AddLocaleToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :locale, :string, index: true, default: 'en'
  end
end

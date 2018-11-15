class SetDefaultLocaleForGuide < ActiveRecord::Migration[4.2]
  def change
    change_column :guides, :locale, :string, default: :en
  end
end

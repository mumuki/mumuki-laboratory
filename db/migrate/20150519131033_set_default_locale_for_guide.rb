class SetDefaultLocaleForGuide < ActiveRecord::Migration
  def change
    change_column :guides, :locale, :string, default: :en
  end
end

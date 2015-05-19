ActiveAdmin.register Category do

  permit_params :name, :description, :locale, :image_url

  filter :name
  filter :description
  filter :locale
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:description)
    column(:locale)
    column(:image_url)

    actions
  end
end

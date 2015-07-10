ActiveAdmin.register Category do

  permit_params :name, :position, :description, :locale, :image_url

  filter :name
  filter :description
  filter :locale
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:position)
    column(:description)
    column(:locale)
    column(:image_url)

    actions
  end
end

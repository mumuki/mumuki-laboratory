ActiveAdmin.register Chapter do

  permit_params :name, :number, :description, :locale

  filter :name
  filter :description
  filter :locale
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:number)
    column(:description)
    column(:locale)

    actions
  end
end

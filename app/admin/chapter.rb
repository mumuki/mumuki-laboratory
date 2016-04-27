ActiveAdmin.register Chapter do

  permit_params :name, :number, :description, :locale, :book

  filter :name
  filter :description
  filter :locale
  filter :created_at
  filter :updated_at
  filter :book

  index do
    column(:id)
    column(:name)
    column(:number)
    column(:description)
    column(:locale)
    column(:book)

    actions
  end
end

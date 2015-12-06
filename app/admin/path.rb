ActiveAdmin.register Path do

  permit_params :category_id, :language_id

  filter :category
  filter :language
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:category)
    column(:language)

    actions
  end
end


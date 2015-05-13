ActiveAdmin.register StartingPoint do

  permit_params :category, :guide, :language

  filter :category
  filter :guide
  filter :language
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:category)
    column(:guide)
    column(:language)

    actions
  end
end


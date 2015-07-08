ActiveAdmin.register Guide do

  permit_params :name, :author_id, :description, :locale, :learning, :beta, :corollary, :github_repository, :position, :path_id, :extra_code

  filter :name
  filter :description
  filter :path
  filter :learning
  filter :beta
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:learning)
    column(:beta)
    column(:path)
    column(:position)
    column(:description)
    column(:github_repository)

    actions
  end
end

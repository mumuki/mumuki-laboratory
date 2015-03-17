ActiveAdmin.register Language do

  permit_params :name, :image_url, :extension, :test_runner_url

  filter :name
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:image_url)
    column(:extension)
    column(:test_runner_url)

    actions
  end
end

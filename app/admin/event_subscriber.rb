ActiveAdmin.register EventSubscriber do

  permit_params :enabled, :url

  filter :url
  filter :enabled

  index do
    column :url
    column :enabled

    actions
  end

  controller do
    def scoped_collection
      EventSubscriber.unscoped.where(type: 'EventSubscriber')
    end
  end

end

ActiveAdmin.register Floor do
  permit_params :name, :building_id, :plan
  scope_to :current_admin_user, association_method: :all_floors, unless: proc{ current_admin_user.super_admin? }
  menu priority: 40

  filter :name
  filter :building

  form :html => { :enctype => "multipart/form-data" } do |f|
      f.inputs "Product", :multipart => true do
      f.input :name
      f.input :building_id, as: :select, collection: current_admin_user.all_buildings.pluck(:name, :id)
      f.input :plan, as: :file, hint: (f.template.image_tag(f.object.plan.url(:thumb)) if f.object.plan?)
    end
    f.actions
  end

  index do |floor|
    column :name
    column :building
    column :plan do |f|
      image_tag(f.plan.url(:thumb))
    end
    actions
  end

  show do |floor|
    attributes_table do
      row :name
      row :plan do
        image_tag(floor.plan.url(:thumb))
      end
    end
  end

end

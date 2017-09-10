ActiveAdmin.register Project do
  menu priority: 20
  scope_to :current_admin_user, association_method: :all_projects, unless: proc{ current_admin_user.super_admin? }

  permit_params :name, :customer_id, :tag_id

  filter :name

  controller do
    def new
      if params[:customer_id]
        @project = Project.new customer_id: params[:customer_id]
      else
        @project = Project.new customer_id: 1
      end
    end
  end

  index :download_links => false do
    column :name
    column :customer do |project|
      link_to project.customer.name, admin_customer_path(project.customer)
    end
    column :buildings do |project|
      if project.buildings.empty?
        link_to 'Add building', new_admin_customer_project_building_path(project.customer,2,3)
      else
        link_to project.buildings.count, admin_customer_project_buildings_path(project.customer,project,5)
      end
    end
    actions
  end


  show :title => :name do |project|
    attributes_table do
      row :tag, :label => 'Reference Tag'
    end
    panel("Buildings") do
      table_for project.buildings do
        column :name do |building|
          link_to building.name, admin_customer_project_buildings_path(building.project.customer, building.project) + '/' + building.id.to_s
        end
        column :floor do |building|
          building.floors.count
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :name
      f.input :customer_id, as: :select, collection: current_admin_user.customers.pluck(:name, :id)
      f.input :tag_id, label: 'Reference Tag', as: :select, collection: current_admin_user.all_tags.pluck(:name, :id)
    end
    f.actions
  end

end

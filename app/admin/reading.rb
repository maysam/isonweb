ActiveAdmin.register Reading do
  menu priority: 60

  filter :tag
  filter :time

  config.sort_order = "time_asc"

  index :download_links => false do
    selectable_column
    column :tag
    column :from do |reading|
      Time.at reading.time/1000
    end
    column :offset do |reading|
      reading.offset/4
    end
    column :log_interval
    column :length do |reading|
      reading.data.length
    end
    column :logs do |reading|
      link_to "Logs(#{reading.logs.count})", :controller => "logs",
        :action => "index", 'q[reading_id_eq]' => "#{reading.id}".html_safe
    end
    column :created_at
    actions
  end

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

end

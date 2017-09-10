ActiveAdmin.register Tag do
  menu priority: 50

  filter :name
  filter :uid

  config.sort_order = "updated_at_asc"

  index :download_links => false do
    column :name
    column :uid
    column :project
    column :building
    column :floor
    column :position do |tag|
      "X: #{tag.x}, Y: #{tag.y}"
    end
    # column :active do |tag|
    #   tag.active?
    # end
    column :latest_reading do |tag|
      max_time = tag.readings.pluck(:time).max
      Time.at max_time/1000 if max_time
    end
    column :readings do |tag|
      link_to "Readings(#{tag.readings.count})", :controller => "readings",
        :action => "index", 'q[tag_id_eq]' => "#{tag.id}".html_safe
    end
    column :logs do |tag|
      link_to "Logs(#{tag.logs.count})", :controller => "logs",
        :action => "index", 'q[tag_id_eq]' => "#{tag.id}".html_safe
    end
    actions
  end
end

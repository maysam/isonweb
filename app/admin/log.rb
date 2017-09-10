ActiveAdmin.register Log do
  config.sort_order = "datetime_asc"
  menu priority: 70

  index do
    column :reading
    column :datetime do |log|
      Time.at log.datetime/1000
    end
    column :temp, label: 'Temperature'
    column :humidity
    column :pressure
  end
end

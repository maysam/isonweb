ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: 'Welcome to ProtectSys' do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     h1 "Welcome to ProtectSys"
    #   end
    # end

    columns do
      # column do
      #   panel "Recent Users" do
      #     ul do
      #       current_admin_user.customers.map do |user|
      #         li link_to(user.email, admin_admin_user_path(user))
      #       end
      #     end
      #   end
      # end

      column do
        panel "Info" do
          para link_to("#{Customer.count} Customers", admin_customers_path)
          para link_to("#{Project.count} Projects", admin_projects_path)
          para link_to("#{Building.count} Buildings", admin_buildings_path)
          para link_to("#{Tag.count} Tags", admin_tags_path)
          para link_to("#{Reading.count} Readings", admin_readings_path)
          para link_to("#{Log.count} Logs", admin_logs_path)
        end
      end
    end
  end
end

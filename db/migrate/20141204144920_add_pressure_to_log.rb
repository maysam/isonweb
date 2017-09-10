class AddPressureToLog < ActiveRecord::Migration
  def change
    add_column :logs, :pressure, :float
  end
end

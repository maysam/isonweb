class AddFieldsToReading < ActiveRecord::Migration
  def change
    add_column :readings, :offset, :integer
    add_column :readings, :log_interval, :integer
    add_column :readings, :time, :bigint
  end
end

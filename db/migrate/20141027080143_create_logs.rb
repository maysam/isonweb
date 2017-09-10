class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.references :tag, index: true
      t.float :temp
      t.float :humidity

      t.timestamps
    end
    add_column :logs, :datetime, :bigint
  end
end

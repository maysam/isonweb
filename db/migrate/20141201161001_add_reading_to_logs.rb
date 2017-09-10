class AddReadingToLogs < ActiveRecord::Migration
  def change
    add_reference :logs, :reading, index: true
  end
end

class MoreDbIndicies < ActiveRecord::Migration
  def change
    add_index :appointments, :request
    add_index :appointments, :appointment_time
  end
end

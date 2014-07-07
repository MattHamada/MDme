class AddBooleanEarierTimeToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :inform_earlier_time, :boolean
  end
end

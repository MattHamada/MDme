class AddCheckinBoolToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :checked_in, :boolean, default: false
  end
end

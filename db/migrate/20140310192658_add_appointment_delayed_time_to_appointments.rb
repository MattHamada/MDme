class AddAppointmentDelayedTimeToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :appointment_delayed_time, :datetime
  end
end

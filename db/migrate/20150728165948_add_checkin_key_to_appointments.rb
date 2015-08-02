class AddCheckinKeyToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :checkin_key, :string
    add_index  :appointments, :checkin_key, unique: true
  end
end

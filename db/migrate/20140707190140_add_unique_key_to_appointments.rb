class AddUniqueKeyToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :access_key, :string, unique: true
  end
end

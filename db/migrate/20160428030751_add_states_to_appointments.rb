class AddStatesToAppointments < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :status, :string
    remove_column :appointments, :checked_in
    remove_column :appointments, :request
  end
end

class AddRequestToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :request, :boolean
  end
end

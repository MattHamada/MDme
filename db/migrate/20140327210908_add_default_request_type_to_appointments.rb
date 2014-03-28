class AddDefaultRequestTypeToAppointments < ActiveRecord::Migration
  def change
    change_column_default :appointments, :request, true
  end
end

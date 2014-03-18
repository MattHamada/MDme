class AddClinicIdToPatientDoctorAppointments < ActiveRecord::Migration
  def change
    add_column :doctors, :clinic_id, :integer
    add_column :appointments, :clinic_id, :integer
    add_column :patients, :clinic_id, :integer

  end
end

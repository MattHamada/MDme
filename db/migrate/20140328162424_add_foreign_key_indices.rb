class AddForeignKeyIndices < ActiveRecord::Migration
  def change
    add_index :admins, :clinic_id
    add_index :appointments, :clinic_id
    add_index :doctors, :clinic_id
    add_index :doctors, :department_id
    add_index :patients, :clinic_id
    add_index :patients, :doctor_id
  end
end

class JoinTableForClinicsPatients < ActiveRecord::Migration
  def change
    create_table :clinics_patients, id: false do |t|
      t.integer :clinic_id
      t.integer :patient_id
    end

    add_index :clinics_patients, :clinic_id
    add_index :clinics_patients, :patient_id

    remove_column :patients, :clinic_id
  end
end

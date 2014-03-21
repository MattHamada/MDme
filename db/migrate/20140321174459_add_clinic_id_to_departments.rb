class AddClinicIdToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :clinic_id, :integer
    add_index :departments, :clinic_id
  end
end

class AddClinicIdToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :clinic_id, :integer
  end
end

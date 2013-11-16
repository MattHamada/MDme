class AddDepartmentIdToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :department_id, :integer
  end
end

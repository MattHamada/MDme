class AddMaritalStatusToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :marital_status, :integer
  end
end

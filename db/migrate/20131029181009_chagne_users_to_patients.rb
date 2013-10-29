class ChagneUsersToPatients < ActiveRecord::Migration
  def change
    rename_table :users, :patients
  end
end

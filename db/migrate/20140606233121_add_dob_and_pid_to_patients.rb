class AddDobAndPidToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :pid, :integer
    add_column :patients, :dob, :date
    add_index :patients, :pid, unique: true
  end
end

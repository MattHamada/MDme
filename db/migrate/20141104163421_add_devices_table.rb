class AddDevicesTable < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :patient_id
      t.string  :token
      t.string  :platform
      t.boolean :enabled, :default => true
      t.timestamps
    end
  end
end

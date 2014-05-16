class AddLotsOfFieldsToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :address, :string
    add_column :patients, :work_phone, :string
    remove_column :patients, :phone_number
    add_column :patients, :home_phone, :string
    add_column :patients, :mobile_phone, :string
  end
end

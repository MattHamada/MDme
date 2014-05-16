class AddLotsOfFieldsToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :address, :string
    add_column :patients, :work_phone, :string
    change_column :patients, :phone_number, :home_phone
    add_column :patients, :mobile_phone, :strings
  end
end

class AddMorePhoneOptionsToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :work_phone_extension, :string
    add_column :patients, :preferred_daytime_phone, :integer
  end
end

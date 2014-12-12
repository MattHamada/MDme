class AddRegistrationFieldsToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :middle_initial,         :string, default: ''
    add_column :patients, :name_prefix,            :string, defualt: ''
    add_column :patients, :name_suffix,            :string, default: ''
    add_column :patients, :birthday,               :date
    add_column :patients, :sex,                    :boolean #MALE = true FEMALE = false
    add_column :patients, :social_security_number, :string, default: ''
  end
end

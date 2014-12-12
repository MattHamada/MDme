class ChangeColumnPatientSexToIsmale < ActiveRecord::Migration
  def change
    rename_column :patients, :sex, :is_male
  end
end

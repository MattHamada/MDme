class ChangePatientIsMaleBooleanToSexInteger < ActiveRecord::Migration
  def change
    remove_column :patients, :is_male
    add_column    :patients, :sex, :integer
  end
end

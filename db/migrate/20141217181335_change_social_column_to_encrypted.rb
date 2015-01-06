class ChangeSocialColumnToEncrypted < ActiveRecord::Migration
  def change
    rename_column :patients, :social_security_number, :encrypted_social_security_number
  end
end

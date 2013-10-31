class AddRememberTokenToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :remember_token, :string
    add_index  :patients, :remember_token
  end
end

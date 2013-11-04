class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :email
      t.string :remember_token
      t.timestamps
    end
    add_index :admins, :email
    add_index :admins, :remember_token
  end
end

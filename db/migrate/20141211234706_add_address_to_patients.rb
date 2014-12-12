class AddAddressToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :address1, :string
    add_column :patients, :address2, :string
    add_column :patients, :city,     :string
    add_column :patients, :state,    :string
    add_column :patients, :zipcode,  :string
  end
end

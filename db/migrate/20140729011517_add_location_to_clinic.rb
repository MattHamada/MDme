class AddLocationToClinic < ActiveRecord::Migration
  def change
    add_index :clinics, :name

    add_column :clinics, :address1, :string
    add_column :clinics, :address2, :string
    add_column :clinics, :address3, :string
    add_column :clinics, :city, :string
    add_column :clinics, :state, :string
    add_column :clinics, :zipcode, :string
    add_column :clinics, :country, :string
    add_column :clinics, :phone_number, :string
    add_column :clinics, :fax_number, :string

  end
end

class AddProfileFieldsToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :phone_number, :string
    add_column :doctors, :degree, :string
    add_column :doctors, :alma_mater, :string
    add_column :doctors, :description, :text
  end
end

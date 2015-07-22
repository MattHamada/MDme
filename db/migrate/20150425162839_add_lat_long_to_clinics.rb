class AddLatLongToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :latitude, :float
    add_column :clinics, :longitude, :float
  end
end

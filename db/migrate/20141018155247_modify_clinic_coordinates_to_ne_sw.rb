class ModifyClinicCoordinatesToNeSw < ActiveRecord::Migration
  def change
    rename_column :clinics, :latitude,     :ne_latitude
    rename_column :clinics, :longitude,    :ne_longitude
    add_column    :clinics, :sw_latitude,  :float
    add_column    :clinics, :sw_longitude, :float
  end
end

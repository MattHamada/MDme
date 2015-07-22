class AddTimeZoneToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :timezone, :string;
  end
end

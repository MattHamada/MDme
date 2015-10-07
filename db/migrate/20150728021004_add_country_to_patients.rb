class AddCountryToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :country, :string
  end
end

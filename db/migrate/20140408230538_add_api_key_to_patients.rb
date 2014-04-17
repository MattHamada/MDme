class AddApiKeyToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :api_key, :string
    add_index :patients, :api_key
  end
end

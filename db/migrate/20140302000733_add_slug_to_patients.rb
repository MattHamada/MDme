class AddSlugToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :slug, :string
    add_index :patients, :slug
  end
end

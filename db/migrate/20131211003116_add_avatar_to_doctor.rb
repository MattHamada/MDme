class AddAvatarToDoctor < ActiveRecord::Migration
  def self.up
    add_attachment :doctors, :avatar
  end

  def self.down
    remove_attachment :doctors, :avatar
  end
end

class AddAttachmentAndPhoneNumberColumnsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :phone_number, :string
    add_attachment :patients, :avatar
  end
end

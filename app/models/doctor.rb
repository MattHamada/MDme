class Doctor < ActiveRecord::Base

  has_many :appointments
  has_many :patients

  has_secure_password
end

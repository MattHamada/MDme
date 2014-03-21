class Clinic < ActiveRecord::Base
  has_many :patients
  #has_many :doctors
  has_many :appointments
  has_many :admins
  has_many :departments
  has_many :doctors
end

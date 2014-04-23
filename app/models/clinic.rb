class Clinic < ActiveRecord::Base
  has_and_belongs_to_many :patients
  #has_many :doctors
  has_many :appointments
  has_many :admins
  has_many :departments
  has_many :doctors

  scope :ordered_name, -> { order(name: :asc) }

end

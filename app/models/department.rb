# Author: Matt Hamada
# Copyright MDme 2014
#
# Department model
# Used to group doctors based on specialty
#

class Department < ActiveRecord::Base
  has_many :doctors
  has_many :clinics, through: :doctors
end

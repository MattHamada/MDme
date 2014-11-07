class Device < ActiveRecord::Base
  belongs_to :patient
  validates_uniqueness_of :token, :scope => :patient_id
end

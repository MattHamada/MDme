class Appointment < ActiveRecord::Base

  validates :appointment_time, presence: true, uniqueness: true
  validates :doctor_id, presence: true
  validates :patient_id, presence:true

  belongs_to :doctor
  belongs_to :patient

  scope :today, -> { where(appointment_time: Date.today...Date.tomorrow) }

end
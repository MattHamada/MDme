class Appointment < ActiveRecord::Base

  validates :appointment_time, presence: true, uniqueness: true
  validates :doctor_id, presence: true
  validates :patient_id, presence:true

  belongs_to :doctor
  belongs_to :patient

  scope :today, -> { where(appointment_time: Date.today...Date.tomorrow) }

  def self.given_date(date)
    Appointment.where(appointment_time: date...date.at_end_of_day)
  end

end

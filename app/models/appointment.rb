class Appointment < ActiveRecord::Base

  validates :appointment_time, presence: true, uniqueness: true
  validate :appointment_time_in_future
  validates :doctor_id, presence: true
  validates :patient_id, presence:true

  belongs_to :doctor
  belongs_to :patient

  scope :today, -> { where(appointment_time: Date.today...Date.tomorrow) }
  scope :requests, -> { where(request: true) }
  scope :confirmed, -> { where(request: false) }

  def self.given_date(date)
    Appointment.where(appointment_time: date...date.at_end_of_day)
  end

  def self.with_doctor(doctor_id)
    Appointment.where(doctor_id: doctor_id)
  end

  def appointment_time_in_future
    if appointment_time.nil?
      errors.add(:appointment_time, "No Date/time entered.")
    else
      errors.add(:appointment_time, "Date/Time must be set in the future.") if appointment_time < DateTime.now
    end
  end

end

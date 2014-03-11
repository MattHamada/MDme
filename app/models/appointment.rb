# Author: Matt Hamada
# Copyright MDme 2014
#
# Appointment model
#
class Appointment < ActiveRecord::Base

  #appointments must be at a unique time in the future
  validates :appointment_time, presence: true, uniqueness: true
  validate :appointment_time_in_future

  #must have a doctor and patient assigned to each appointment
  validates :doctor_id, presence: true
  validates :patient_id, presence:true

  before_create { self.appointment_delayed_time = appointment_time }


  belongs_to :doctor
  belongs_to :patient

  scope :today, -> { where(appointment_time: Date.today...Date.tomorrow) }
  scope :requests, -> { where(request: true) }
  scope :confirmed, -> { where(request: false) }

  # returns all appointments on a specific date
  def self.given_date(date)
    Appointment.where(appointment_time: date...date.at_end_of_day)
  end

  def self.remaining_appointments_today(appt)
    Appointment.today.with_doctor(appt.doctor_id).
        where(appointment_time: appt.appointment_time+1.minute...DateTime.tomorrow)
  end

  # returns all appointments with a given doctor
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

  #for calculating delays based on selection box
  def self.get_added_time(selection)
    case selection
      when 1
        return 5
      when 2
        return 10
      when 3
        return 15
      when 4
        return 20
      when 5
        return 30
      when 6
        return 45
      when 7
        return 60
    end
  end

  def self.update_remaining_appointments!(appointment, time_to_add)
      remaining_appointments_today(appointment).each do |appt|
         appt.update_attribute(:appointment_delayed_time,
                               appt.appointment_time + time_to_add.minutes)
      end
  end

end

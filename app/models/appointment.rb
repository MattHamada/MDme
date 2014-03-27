# Author: Matt Hamada
# Copyright MDme 2014
#
# Appointment model
#

require 'appointment_time_formatting'

class Appointment < ActiveRecord::Base
  include AppointmentTimeFormatting

  belongs_to :doctor
  belongs_to :patient
  belongs_to :clinic

  delegate :full_name, to: :doctor, prefix: true
  delegate :full_name, to: :patient, prefix: true

  #appointments must be at a unique time in the future
  validates :appointment_time, presence: true
  validate :appointment_unique_with_doctor_in_clinic
  validate :appointment_time_in_future
  #must have a doctor and patient assigned to each appointment
  validates :doctor_id,  presence: true
  validates :patient_id, presence: true
  validates :clinic_id,  presence: true

  before_create { self.appointment_delayed_time = appointment_time }

  scope :today, -> { where(appointment_time: Date.today...Date.tomorrow) }
  scope :requests, -> { where(request: true) }
  scope :confirmed, -> { where(request: false) }


  # returns all appointments on a specific date
  def self.given_date(date)
    Appointment.where(appointment_time: date...date.at_end_of_day)
  end

  def self.not_past
    Appointment.where(Appointment.arel_table[:appointment_time].
                          gt(DateTime.now)).load
  end

  def remaining_appointments_today
    Appointment.today.with_doctor(doctor_id).
        where(appointment_time: appointment_time+1.minute...DateTime.tomorrow)
  end

  # returns all appointments with a given doctor
  def self.with_doctor(doctor_id)
    Appointment.where(doctor_id: doctor_id)
  end

  def self.with_patient(patient_id)
    Appointment.where(patient_id: patient_id)
  end

  def self.confirmed_today_with_doctor(doctor_id)
    Appointment.given_date(Date.today).confirmed.
        with_doctor(doctor_id).order('appointment_time ASC').load
  end

  def self.order_by_time
    Appointment.order('appointment_time ASC').load
  end

  def self.in_clinic(model)
    if model.is_a?(Appointment)
      Appointment.where(clinic_id: model.clinic_id).where.not(id: model.id)
    else
      Appointment.where(clinic_id: model.clinic_id)
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
      else
        return 0
    end
  end

  def email_confirmation_to_patient(choice)
    if choice == :approve
      Thread.new do
        PatientMailer.appointment_confirmation_email(self).deliver
      end
    elsif choice == :deny
      Thread.new do
        PatientMailer.appointment_deny_email(self).deliver
      end
    end

  end

  def send_delay_email
    Thread.new do
      PatientMailer.appointment_delayed_email(patient,
                                             appointment_delayed_time).deliver
    end
  end

  def update_remaining_appointments!(time_to_add)
      remaining_appointments_today.each do |appt|
         appt.update_attribute(:appointment_delayed_time,
                            appt.appointment_delayed_time + time_to_add.minutes)
         appt.send_delay_email
      end
  end

  def appointment_time_in_future
    if appointment_time.nil?
      errors.add(:appointment_time, "No Date/time entered.")
    else
      errors.add(:appointment_time, "Date/Time must be set in the future.") if
          appointment_time < DateTime.now
    end
  end

  def appointment_unique_with_doctor_in_clinic
    times_taken = []
    begin
      self.doctor.appointments.confirmed.each do |appt|
        unless appt.id == self.id
          times_taken << appt.appointment_time
        end
      end
    rescue NoMethodError
      errors.add(:doctor_id, 'No doctor specified')
    end
    errors.add(:appointment_time, "Time not available") if times_taken.include?(appointment_time)
  end

end

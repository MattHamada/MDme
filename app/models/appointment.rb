# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 11/4/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +Appointment+ model
require 'appointment_time_formatting'

class Appointment < ActiveRecord::Base
  include AppointmentTimeFormatting

  belongs_to :doctor
  belongs_to :patient
  belongs_to :clinic

  delegate :full_name, to: :doctor,  prefix: true
  delegate :full_name, to: :patient, prefix: true
  delegate :name,      to: :clinic,  prefix: true

  # Appointments must be at a unique time for patient and doctor in the future
  validates :appointment_time, presence: true
  validate :appointment_unique_with_doctor_in_clinic
  validate :appointment_time_in_future
  # Must have a clinic, doctor, and patient assigned to each appointment
  validates :doctor_id,  presence: true
  validates :patient_id, presence: true
  validates :clinic_id,  presence: true

  # Set delayed_time to set time when created to avoid nulls
  before_create { self.appointment_delayed_time = appointment_time }

  before_create { generate_access_key }

  scope :today, -> { where(appointment_time: Date.today...Date.tomorrow) }
  scope :within_2_hours, -> { where(
  appointment_time: DateTime.now...(DateTime.now + 2.hours)) }

  # True is a patient request not an admin forcing a new appointment
  scope :requests, -> { where(request: true) }

  # Confirmed appointments are approved requests
  scope :confirmed, -> { where(request: false) }

  # When these appointments were created the patient requested
  # notice of earlier availabilities
  scope :looking_for_earlier_time, -> { where(inform_earlier_time: true) }

  # Part of appointment time recycling
  # Will find next appointment after canceled one and email the patient
  # about the availability
  # ==== Parameters
  # * +time_to_fill+ - the canceled appointment's time
  # * +look_time_start+ - look for appointments on or after this time
  # to fill opening
  def self.fill_canceled_appointment(time_to_fill, look_time_start)
    appointment = Appointment.looking_for_earlier_time.same_day_after_time(
        look_time_start).first
    appointment.patient.email_about_open_time(
        appointment, time_to_fill) unless appointment.nil?
  end

  # returns all appointments on a specific date
  # ==== Parameters
  # * +date+ - date object to fine appointments on
  def self.given_date(date)
    Appointment.where(appointment_time: date...date.at_end_of_day)
  end


  # return all appointments on the given date after the given time
  # ==== Parameters
  # * +date_time+ - date_time object to find appointments after
  def self.same_day_after_time(date_time)
    Appointment.where(appointment_time: date_time+1.minute..date_time.at_end_of_day).order_by_time
  end

  # returns appointments that have not past
  # TODO should this use delayed time?
  def self.not_past
    Appointment.where(Appointment.arel_table[:appointment_time].
                          gt(DateTime.now)).load
  end

  # Returns all appointments with a given doctor
  # ==== Parameters
  # * +doctor_id+ - the +doctor_id+ of the doctor stored in the appointment
  def self.with_doctor(doctor_id)
    Appointment.where(doctor_id: doctor_id)
  end

  # Returns all appointments with a given patient
  # ==== Parameters
  # * +patient_id+ - the +patient_id+ of the patient stored in the appointment
  def self.with_patient(patient_id)
    Appointment.where(patient_id: patient_id)
  end

  # Returns all confirmed appointments today with a given doctor
  # ==== Parameters
  # * +doctor_id+ - the +doctor_id+ of the doctor stored in the appointment
  def self.confirmed_today_with_doctor(doctor_id)
    Appointment.given_date(Date.today).confirmed.
        with_doctor(doctor_id).order('appointment_time ASC').load
  end

  # Returns appointments in order of earliest +appointment_time+ first.
  # used for ordering queries
  def self.order_by_time
    Appointment.order('appointment_time ASC').load
  end

  # Checks to see if the passed Clinic/Appointment/Doctor/Patient has the same
  # +id+ or +clinic_id+ as the appointment. Returns all appointments in the
  # same clinic
  # ==== Parameters
  # * +model+ - object to get id from to check against appointments
  def self.in_clinic(model)
    if model.is_a?(Appointment)
      Appointment.where(clinic_id: model.clinic_id).where.not(id: model.id)
    elsif model.is_a?(Clinic)
      Appointment.where(clinic_id: model.id)
    else
      Appointment.where(clinic_id: model.clinic_id)
    end
  end

  # Converts time chosen from selection box on appointment
  # creation or editing pages from selection indicies to minutes.
  # ==== Parameters
  # * +selection+ - The selection index chosen
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

  # This key is used when recycling canceled appointment times
  # It is used to verify that the appointment approved to be moved up in time
  # is the one actually being moved up
  # See AppointmentsController#fill_appointments
  def generate_access_key
    self.access_key = Digest::SHA1.hexdigest(SecureRandom.urlsafe_base64)
  end


  # Returns all remaining appointments remaining with the same doctor as the
  # calling instance for the day. Should not be called on appointments
  # whose +appointment_time+ is not today
  def remaining_appointments_today
    Appointment.today.with_doctor(doctor_id).
        where(appointment_time: appointment_time+1.minute...DateTime.tomorrow)
  end

  # Emails the patient whether their appointment request was approved or denied.
  # Uses a separate thread to send the email
  # ==== Parameters
  # * +choice+ - symbol either :approve or :deny
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

  # Emails patient informing them their appointment hsa been delayed.
  # Uses a separate thread
  def send_delay_email
    Thread.new do
      PatientMailer.appointment_delayed_email(patient,
                                              appointment_delayed_time).deliver
    end
  end

  # Will send GCM message to android devices registered to patient
  # Informs patient of delay and new time
  # TODO also add iphone support for future iphone app
  def push_delay_notification
    droid_destinations = patient.devices.map do |device|
      device.token if device.platform == 'android' && device.enabled
    end
    data = {:type => "DELAY", appointment_id => id, :message =>
      "Your appointment time has changed. Your appointment with #{clinic.name}" +
      " is now set to #{delayed_date_time_ampm}" }
    Thread.new do
      GCM.send_notification(droid_destinations, data) unless droid_destinations.empty?
    end
  end


  # Will send GCM message to android devices registered to patient
  # Informs patient their appointment is ready
  # TODO also add iphone support for future iphone app
  def push_notify_ready
    droid_destinations = patient.devices.map do |device|
      device.token if device.platform == 'android' && device.enabled
    end
    data = {:type => "READY", :message =>
        "Your appointment with #{clinic.name} at #{delayed_date_time_ampm} is ready" }
    Thread.new do
      GCM.send_notification(droid_destinations, data) unless droid_destinations.empty?
    end
  end

  # Adds time to each appointment found by #remaining_appointments_today due
  # to a delay.  Also signals to send delay notification to patient .
  # Only delays appointments with same doctor_id  (from remaining_appointments_today)
  # ==== Parameters
  # * +time_to_add+ - minutes to add to each appointment
  def update_remaining_appointments!(time_to_add)
      remaining_appointments_today.each do |appt|
         appt.update_attribute(:appointment_delayed_time,
                            appt.appointment_delayed_time + time_to_add.minutes)
         appt.send_delay_email
         appt.push_delay_notification
      end
  end

  # Used to verify a valid appointment was chosen during create/edit
  def appointment_time_in_future
    if appointment_time.nil?
      errors.add(:appointment_time, "No Date/time entered.")
    else
      errors.add(:appointment_time, "Date/Time must be set in the future.") if
          appointment_time < DateTime.now
    end
  end

  # Verifies appointment does not overlap with another of the same doctor in
  # the clinic
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

# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/30/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +Doctor+ class
require 'cookie_crypt'
require 'user_common_instance'
#require 'user_common_class'


class Doctor < ActiveRecord::Base
  #extend UserCommonClass
  include CookieCrypt, UserCommonInstance

  has_many :appointments, dependent: :destroy
  has_many :patients
  #belongs_to :clinic
  belongs_to :department

  delegate :name, to: :department, prefix: true

  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  validates :clinic_id, presence: true


  attr_accessor :is_admin_applying_update
  attr_accessor :skip_on_create

  has_secure_password

  has_attached_file :avatar, :styles => { :medium => "300x300>",
                                          :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"

  VALID_CONTENT_TYPES = ["application/octet-stream", "image/jpg",
                         "image/jpeg", "image/gif", "image/png"]
  # Paperclip sees photos uploaded from android app as
  # octet-stream and not image/jpeg.  This is a work around
  before_validation do |file|
    if file.avatar_content_type == 'application/octet-stream'
      mime_type = MIME::Types.type_for(file.avatar_file_name)
      file.avatar_content_type = mime_type.first.content_type if mime_type.first
    end
  end

  validate :attachment_content_type
  do_not_validate_attachment_file_type :avatar
  validates_attachment :avatar,
                       :size => { :in => 0..10.megabytes }

  # Sort doctors alphabetically by last name
  scope :ordered_last_name, -> { order(last_name: :asc) }

  # Finds doctor by first and last name
  # ==== Parameters
  # * +full_name+ doctor's full name formatted first_name_last_name
  # * +clinic_id+ the clinic id associated with the doctor
  def self.find_by_full_name(full_name, clinic_id)
    first_name = full_name.match(/^([\w\-.]+)/)[0]
    last_name = full_name.match(/(\w+)$/)[0]
    Doctor.where(first_name: first_name,
                 last_name: last_name,
                 clinic_id: clinic_id).first
  end


  # Finds all other doctors in the same clinic as +model+
  # ==== Parameters
  # * +model+ - model passed to get get doctors in same clinic.  Model
  # can be clinic or have a +clinic_id+
  def self.in_clinic(model)
    if model.is_a?(self)
      self.where(clinic_id: model.clinic_id).where.not(id: model.id)
    elsif model.is_a?(Patient)
      clinic_ids = []
      model.clinics.each { |c| clinic_ids << c.id }
      #self.find_by_clinic_id(clinic_ids)
      self.where(clinic_id: clinic_ids)
    elsif model.is_a?(Clinic)
      self.where(clinic_id: model.id)
    else
      self.where(clinic_id: model.clinic_id)
    end
  end

  # Returns doctors who have confirmed appointments today
  def self.with_appointments_today
    Doctor.joins(:appointments).merge(Appointment.today.confirmed).uniq
  end

  # Returns all doctors in the passed department instance
  #==== Parameters
  # * +department+ - A department instance
  def self.in_department(department)
    Doctor.where(department_id: department.id).where(clinic_id: department.clinic_id)
  end

  # Returns string array of all open appointment times
  # on a given day in am/pm format.  Used for populating a selection box
  # on a web form for creating/editing appointments
  #===== Parameters
  # * +date+ - A Date object
  def open_appointment_times(date)
    appointments = self.appointments.given_date(date).confirmed
    times = []
    (9..16).each do |h|
      (0..45).step(15) do |m|

        ampm = ''
        if h < 12
          ampm = 'AM'
        else
          ampm = 'PM'
        end

        hr = ''
        if h != 12
          hr = h % 12
        else
          hr = h
        end
        min = ''
        if m == 0
          min = '00'
        else
          min = m
        end
        #h = h % 12 if h != 12

        times.append("#{hr}:#{min} #{ampm}")
      end
    end
    appointments.find_each do |appt|
      hour = appt.appointment_time_hour_24
      minute = appt.appointment_time_minute
      minute = '00' if minute == 0

      ampm = ''
      if hour < 12
        ampm = 'AM'
      else
        ampm = 'PM'
      end
      hour = hour % 12 if hour != 12
      if times.include?("#{hour}:#{minute} #{ampm}")
        times.delete("#{hour}:#{minute} #{ampm}")
      end
    end
    times
  end

  # Return collection of doctor's appointments for hte day
  def appointments_today
    appointments.today.order('appointment_time ASC')
  end

  # Paperclip sees photos uploaded from android app as
  # octet-stream and not image/jpeg.  This is a work around
  def attachment_content_type
    unless self.avatar_content_type.nil?
      errors.add(:avatar, "type is not allowed") unless VALID_CONTENT_TYPES.
          include?(self.avatar_content_type)
    end
  end

  # View helpers
  def avatar_thumb_url
    avatar.url(:thumb)
  end

  def avatar_medium_url
    avatar.url(:medium)
  end

  def education
    "#{degree}; #{alma_mater}"
  end

  # def full_name
  #   "#{first_name} #{last_name}"
  # end



end

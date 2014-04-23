# Author: Matt Hamada
# Copyright MDme 2014
#
# Doctor model
#
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
  validates_attachment :avatar,
                       :content_type => { :content_type => ["application/octet-stream", "image/jpg", "image/jpeg", "image/gif", "image/png"] },
                       :size => { :in => 0..10.megabytes }

  scope :ordered_last_name, -> { order(last_name: :asc) }

  # def self.in_clinic(model)
  #   if model.is_a?(Doctor)
  #     Doctor.where(clinic_id: model.clinic_id).where.not(id: model.id)
  #   else
  #     Doctor.where(clinic_id: model.clinic_id)
  #   end
  # end
  #
  # def full_name
  #   "#{first_name} #{last_name}"
  # end

  # returns string array of all open appointment times
  # on a given day in am/pm format
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
      hour = appt.appointment_time_hour
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

  def self.in_clinic(model)
    if model.is_a?(self)
      self.where(clinic_id: model.clinic_id).where.not(id: model.id)
    elsif model.is_a?(Patient)
      clinic_ids = []
      model.clinics.each { |c| clinic_ids << c.id }
      #self.find_by_clinic_id(clinic_ids)
      self.where(clinic_id: clinic_ids)
    else
      self.where(clinic_id: model.clinic_id)
    end
  end

  def self.in_passed_clinic_model(clinic)
    Doctor.where(clinic_id: clinic.id)
  end


  def self.with_appointments_today
    doctors = []
    Doctor.find_each do |d|
      doctors << d unless d.appointments.today.load.empty?
    end
    doctors
  end

  def appointments_today
    appointments.today.order('appointment_time ASC')
  end

  def self.in_department(department)
    Doctor.where(department_id: department.id).where(clinic_id: department.clinic_id)
  end

  def avatar_thumb_url
    avatar.url(:thumb)
  end

  def avatar_medium_url
    avatar.url(:medium)
  end

  def education
    "#{degree}; #{alma_mater}"
  end

  def self.find_by_full_name(full_name, clinic_id)
    first_name = full_name.match(/^([\w\-.]+)/)[0]
    last_name = full_name.match(/(\w+)$/)[0]
    Doctor.where(first_name: first_name,
                 last_name: last_name,
                 clinic_id: clinic_id).first
  end

end

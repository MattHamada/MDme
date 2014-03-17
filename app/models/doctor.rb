# Author: Matt Hamada
# Copyright MDme 2014
#
# Doctor model
#
require 'cookie_crypt'


class Doctor < ActiveRecord::Base
  include CookieCrypt


  before_validation :generate_slug

  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}

  # cannot register multiple doctors under one email address
  validates :email, presence: true, uniqueness: {case_sensitive: false}, email_format: true

  validates :clinic_id, presence: true

  # passwords must be length of 6
  # skips validation if admin is updating doctor info
  validates :password, password_complexity: true, presence: true,
                                unless: :is_admin_applying_update


  validates :slug, presence: true #unless: :skip_on_create
  validate :slug_unique_in_clinic


  attr_accessor :is_admin_applying_update
  attr_accessor :skip_on_create
  has_attached_file :avatar, :styles => { :medium => "300x300>",
                                          :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"

  # emails stored lowercase
  before_save { self.email = email.downcase }
  before_create :create_remember_token


  has_many :appointments
  has_many :patients
  belongs_to :clinic
  belongs_to :department

  has_secure_password

  delegate :name, to: :department, prefix: true

  def doctor_full_name
    doctor.full_name
  end

  def patient_full_name
    patient.full_name
  end

  def self.in_clinic(model)
    if model.is_a?(Doctor)
      Doctor.where(clinic_id: model.clinic_id).where.not(id: model.id)
    else
      Doctor.where(clinic_id: model.clinic_id)
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # returns string array of all open appointment times
  # on a given day in am/pm format
  def open_appointment_times(date)
    appointments = self.appointments.given_date(date)
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
      hour = appt.appointment_time_hour + 7
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

  def slug_unique_in_clinic
    errors.add(:slug, "Slug: #{slug} already in use") unless
        slug_unique_in_clinic?
  end

  def slug_unique_in_clinic?
    Doctor.in_clinic(self).where(slug: slug).count == 0
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


  def to_param
    slug
  end

  def generate_slug
    if !full_name.blank?
      if Doctor.in_clinic(self).where(slug: full_name.parameterize).count != 0
        n = 1
        while Doctor.where(slug: "#{full_name.parameterize}-#{n}").count != 0
          n+= 1
        end
        self.slug ||= "#{full_name.parameterize}-#{n}"
      else
        self.slug ||= full_name.parameterize
      end
    else
      self.slug = 'no-name-entered'.parameterize
    end
  end

  def send_password_reset_email(temppass)
    Thread.new do
      PasswordResetMailer.reset_email(self, temppass).deliver
    end
  end

  private

  def create_remember_token
    self.remember_token = encrypt(new_remember_token)
  end

end
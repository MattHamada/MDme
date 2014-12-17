# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/28/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +Patient+ class
require 'cookie_crypt'
require 'user_common_instance'
require 'user_common_class'


class Patient < ActiveRecord::Base
  extend UserCommonClass
  include CookieCrypt, UserCommonInstance

  belongs_to  :doctor
  has_many :devices
  has_many :appointments, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_and_belongs_to_many :clinics

  #TODO store social encrypted

  validates :first_name,             presence: true, length: {maximum: 50}
  validates :last_name,              presence: true, length: {maximum: 50}
  validates :sex,                    presence: true
  validates :social_security_number, presence: true, length: {maximum: 11}
  validates :address1,               presence: true, length: {maximum: 100}
  validates :city,                   presence: true, length: {maximum: 50}
  validates :state,                  presence: true, length: {maximum: 2}
  validates :zipcode,                presence: true, length: {maximum: 11}
  validates :birthday,               presence: true
  validate  :birthday_in_past
  validates :middle_initial,                         length: {maximum: 1}
  validates_uniqueness_of :social_security_number

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
  # Paperclip sees photos uploaded from android app as
  # octet-stream and not image/jpeg.  This is a work around
  def attachment_content_type
    unless self.avatar_content_type.nil?
      errors.add(:avatar, "type is not allowed") unless VALID_CONTENT_TYPES.
          include?(self.avatar_content_type)
    end
  end
  do_not_validate_attachment_file_type :avatar
  validates_attachment :avatar,
                       :size => { :in => 0..10.megabytes }

  # validates_attachment_content_type :avatar,
  #                                   :content_type =>   { :content_type =>
  # ["application/octet-stream", "image/jpg", "image/jpeg", "image/gif", "image/png"] },
  #                                   :size => { :in => 0..10.megabytes }

  def birthday_in_past
    if birthday.nil?
      errors.add(:birthday, "No birthday entered.")
    else
      errors.add(:birthday, "Birthday date must be set in the past.") if
          birthday > Date.today
    end
  end

  has_secure_password

  scope :ordered_last_name, -> { order(last_name: :asc)}

  # Returns patients in the same clinic as the passed model
  # ==== Parameters
  # * +model+ - model to get +clinic_id+ to match againt patients
  def self.in_clinic(model)
    if model.is_a? Patient
      Patient.joins(:clinics).where(clinics: { id: model.clinic_id }).where.not(id: model.id)
    else
      Patient.joins(:clinics).where(clinics: { id: model.clinic_id })
    end
  end


  # Used when an appointment was canceled to notify this patient about opening
  # Uses separate thread to send email
  # ==== Parameters
  # * +orig_appointment+ - The canceled appointment
  # * +new_time+ - The new available open time
  def email_about_open_time(orig_appointment, new_time)
    Thread.new do
      FillAppointmentMailer.ask_fill_appointment(self, orig_appointment, new_time).deliver
    end
  end

  # Verify mobile client api token
  # ==== Parameters
  # * +api_token+ - passed client api token to verify
  def api_authenticate(api_token)
    if self.remember_token == encrypt(api_token)
      true
    else
      false
    end
  end

  # Returns next confirmed appointment in the next two hours
  def upcoming_appointment
    self.appointments.within_2_hours.not_past.confirmed.order_by_time.first
  end

  # Returns next confirmed appointment for patient to check in
  def checkin_appointment(clinic)
    self.appointments.in_clinic(clinic).today.not_past.confirmed.
        order_by_time.first
  end

  # View helpers
  def avatar_thumb_url
    avatar.url(:thumb)
  end

  def avatar_medium_url
    avatar.url(:medium)
  end

  class MaritalStatus
    SINGLE = 0
    MARRIED = 1
    DIVORCED = 2
    WIDOWED = 3
    OTHER = 4
  end

  class PreferredDaytimePhone
    HOME = 0
    WORK = 1
    CELL = 2
  end

  class Sex
    MALE   = 0
    FEMALE = 1
  end
end


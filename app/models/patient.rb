# Author: Matt Hamada
# Copyright MDme 2014
#
# Patient model
#
require 'cookie_crypt'
require 'user_common_instance'
require 'user_common_class'


class Patient < ActiveRecord::Base
  extend UserCommonClass
  include CookieCrypt, UserCommonInstance

  belongs_to  :doctor
  has_many :appointments, dependent: :destroy
  has_and_belongs_to_many :clinics

  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}

  has_attached_file :avatar, :styles => { :medium => "300x300>",
                                          :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"

  VALID_CONTENT_TYPES = ["application/octet-stream", "image/jpg", "image/jpeg", "image/gif", "image/png"]

  before_validation do |file|
    if file.avatar_content_type == 'application/octet-stream'
      mime_type = MIME::Types.type_for(file.avatar_file_name)
      file.avatar_content_type = mime_type.first.content_type if mime_type.first
    end
  end

  validate :attachment_content_type

  def attachment_content_type
    unless self.avatar_content_type.nil?
      errors.add(:avatar, "type is not allowed") unless VALID_CONTENT_TYPES.include?(self.avatar_content_type)
    end
  end
  do_not_validate_attachment_file_type :avatar
  validates_attachment :avatar,
                       :size => { :in => 0..10.megabytes }

  # validates_attachment_content_type :avatar,
  #                                   :content_type =>   { :content_type => ["application/octet-stream", "image/jpg", "image/jpeg", "image/gif", "image/png"] },
  #                                   :size => { :in => 0..10.megabytes }

  has_secure_password

  scope :ordered_last_name, -> { order(last_name: :asc)}


  def api_authenticate(api_token)
    if self.remember_token == encrypt(api_token)
      true
    else
      false
    end
  end

  def avatar_thumb_url
    avatar.url(:thumb)
  end

  def avatar_medium_url
    avatar.url(:medium)
  end

  def self.in_clinic(model)
    if model.is_a? Patient
      Patient.joins(:clinics).where(clinics: { id: model.clinic_id }).where.not(id: model.id)
    else
      Patient.joins(:clinics).where(clinics: { id: model.clinic_id })
    end
  end

end


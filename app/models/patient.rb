# Author: Matt Hamada
# Copyright MDme 2014
#
# Patient model
#
require 'cookie_crypt'


class Patient < ActiveRecord::Base
  include CookieCrypt, RocketPants::Cacheable #for future API use

  belongs_to  :doctor
  belongs_to  :clinic
  has_many :appointments

  # accept valid email addresses only
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  validates :email, presence: true, uniqueness: {case_sensitive: false},
            email_format: true
  validates :clinic_id, presence: true
  validates :password, password_complexity: true,
            unless: :is_admin_applying_update
  validates :slug, presence: true
  validate :slug_unique_in_clinic

  before_validation :generate_slug
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  after_create :send_confirmation_email

  attr_accessor :is_admin_applying_update

  has_secure_password

  scope :ordered_last_name, -> { order(last_name: :asc)}


  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_slug
    if !full_name.blank?
      if Patient.in_clinic(self).where(slug: full_name.parameterize).count != 0
        n = 1
        while Patient.where(slug: "#{full_name.parameterize}-#{n}").count != 0
          n+= 1
        end
        self.slug = "#{full_name.parameterize}-#{n}"
      else
        self.slug =  full_name.parameterize
      end
    else
      slug = 'no-name-entered'.parameterize
    end
  end

  def self.in_clinic(model)
    if model.is_a?(Patient)
      Patient.where(clinic_id: model.clinic_id).where.not(id: model.id)
    else
      Patient.where(clinic_id: model.clinic_id)
    end
  end

  def slug_unique_in_clinic
    errors.add(:slug, "Slug: #{slug} already in use") unless
        slug_unique_in_clinic?
  end

  def slug_unique_in_clinic?
    Patient.in_clinic(self).where(slug: slug).count == 0
  end




  def send_password_reset_email(temppass)
    Thread.new do
      PasswordResetMailer.reset_email(self, temppass).deliver
    end
  end

  def to_param
    slug
  end

  private

  def send_confirmation_email
    Thread.new do
      SignupMailer.signup_confirmation(self, password).deliver
    end
  end

    def create_remember_token
      self.remember_token = encrypt(new_remember_token)
    end

end

# Author: Matt Hamada
# Copyright MDme 2014
#
# Patient model
#
require 'cookie_crypt'


class Patient < ActiveRecord::Base
  include CookieCrypt, RocketPants::Cacheable #for future API use

  # accept valid email addresses only
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}

  # cannot register multiple users under one email address
  validates :email, presence: true, uniqueness: {case_sensitive: false}, email_format: true


  validates :password, password_complexity: true, unless: :is_admin_applying_update

  validates :slug, uniqueness: true, presence: true

  before_validation :generate_slug


  attr_accessor :is_admin_applying_update

  # emails stored lowercase
  before_save { self.email = email.downcase }

  before_create :create_remember_token

  belongs_to  :doctor
  has_many :appointments

  has_secure_password


  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_slug
    self.slug ||= full_name.parameterize
  end


  def send_password_reset_email(temppass)
    Thread.new do
      PasswordResetMailer.reset_email(self, temppass).deliver
    end
  end

  def to_param
    slug
    #"#{id} #{full_name}".parameterize
  end

  private

    def create_remember_token
      self.remember_token = encrypt(new_remember_token)
    end

end

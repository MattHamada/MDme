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
  validates :email, presence: true, uniqueness: {case_sensitive: false}, email: true


  validates :password, length: { minimum: 6 }, unless: :is_admin_applying_update
  validate :password_complexity, unless: :is_admin_admin_applying_update

  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d). /)
      errors.add :password, "Must include at least one lowercase letter, one uppercase letter, and one digit"
    end
  end

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




  def to_param
    slug
    #"#{id} #{full_name}".parameterize
  end

  private

    def create_remember_token
      self.remember_token = encrypt(new_remember_token)
    end

end

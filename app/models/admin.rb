# Author: Matt Hamada
# Copyright MDme 2014
#
# Admin model
#
require 'cookie_crypt'


class Admin < ActiveRecord::Base
  include CookieCrypt


  # cannot register multiple admins under one email address
  validates :email, presence: true, uniqueness: {case_sensitive: false}, email_format: true


  validates :password, password_complexity: true

  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d). /)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit"
    end
  end

  # emails stored lowercase
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_secure_password

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

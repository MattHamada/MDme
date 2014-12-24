# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 11/4/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +Admin+ model
# Account information for admin users
require 'cookie_crypt'

class Admin < ActiveRecord::Base
  include CookieCrypt


  # Cannot register multiple admins under one email address
  validates :email, presence: true,
                    uniqueness: {case_sensitive: false},
                    email_format: true

  # Passwords must have one lowercase letter, one uppercase letter, and one digit
  validates :password, password_complexity: true
  #validates :clinic_id, presence: true

  before_save { self.email = email.downcase }

  # Cookie data used to store session login in web browsers
  before_create :create_remember_token

  has_secure_password

  delegate :departments, to: :clinic, prefix: true

  belongs_to :clinic

  # Sends a new password to admin's email
  # Uses a separate thread so server does not hang while processing email
  # ==== Parameters
  # * +temppass+ - new password generated for the account
  def send_password_reset_email(temppass)
    PasswordResetMailer.reset_email(self, temppass).deliver_later
  end

  private

  # Used when admin first created and each subsequent login through browser
  # Creates session info for cookie
  def create_remember_token
    self.remember_token = my_encrypt(new_remember_token)
  end

end

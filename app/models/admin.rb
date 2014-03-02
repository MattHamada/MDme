# Author: Matt Hamada
# Copyright MDme 2014
#
# Admin model
#
require 'cookie_crypt'


class Admin < ActiveRecord::Base
  include CookieCrypt


  # cannot register multiple admins under one email address
  validates :email, presence: true, uniqueness: {case_sensitive: false}, email: true

  # passwords must be length of 6
  #TODO increase password strength
  validates :password, length: { minimum: 6 }

  # emails stored lowercase
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_secure_password

  private

  def create_remember_token
    self.remember_token = encrypt(new_remember_token)
  end

end

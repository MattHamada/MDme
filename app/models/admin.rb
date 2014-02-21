# Author: Matt Hamada
# Copyright MDme 2014
#
# Admin model
#


class Admin < ActiveRecord::Base

  # accept valid email addresses only
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # cannot register multiple admins under one email address
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}

  # passwords must be length of 6
  #TODO increase password strength
  validates :password, length: { minimum: 6 }

  # emails stored lowercase
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_secure_password

  private

  #TODO move token creation out of patient model
  def create_remember_token
    self.remember_token = Patient.encrypt(Patient.new_remember_token)
  end

end

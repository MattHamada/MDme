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
  include CookieCrypt, UserCommonInstance, RocketPants::Cacheable #for future API use


  belongs_to  :doctor
  has_many :appointments

  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}


  has_secure_password

  scope :ordered_last_name, -> { order(last_name: :asc)}

end


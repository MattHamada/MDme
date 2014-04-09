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
  has_many :appointments, dependent: :destroy

  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}

  has_attached_file :avatar, :styles => { :medium => "300x300>",
                                          :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"
  validates_attachment :avatar,
                       :content_type => { :content_type => ["application/octet-stream", "image/jpg", "image/jpeg", "image/gif", "image/png"] },
                       :size => { :in => 0..10.megabytes }


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

end


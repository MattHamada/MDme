# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/14/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +Clinic+ model.  Stores geolocation of clinic obtianed from
# Google's geocode api.  Coordinates will be null if no valid address
# information is supplied
class Clinic < ActiveRecord::Base
  has_and_belongs_to_many :patients
  has_many :appointments
  has_many :admins
  has_many :departments
  has_many :doctors

  validates  :name, presence: true, length: { maximum: 30 }
  validates  :slug, presence: true, uniqueness: true;

  before_validation :generate_slug
  before_save :set_location_coordinates

  # Order clinics alphabetically by name
  scope :ordered_name, -> { order(name: :asc) }

  # Called on clinic creation
  # Calls google geolocation api for latitude/longitude coordinates of
  # the clinic address.  Grabs NE and SW viewport coordinates for easier
  # google map rendering
  # will not change coordinates if invalid address supplied
  def set_location_coordinates
    address = "#{self.address1}+" +
                        "#{self.address2 unless self.address2.nil?}+" +
                        "#{self.address3 unless self.address3.nil?}+" +
                        ", #{self.city}+" +
                        ", #{self.state unless self.state.nil?}+" +
                        "#{self.country}"
    address.gsub!(' ', '+')
    response = call_google_api_for_location(address)
    json = JSON.parse(response)
    unless json['results'].empty?
      #latitude = json['results'][0]['geometry']['location']['lat']
      #longitude = json['results'][0]['geometry']['location']['lng']
      ne_latitude  = json['results'][0]['geometry']['viewport']['northeast']['lat']
      ne_longitude = json['results'][0]['geometry']['viewport']['northeast']['lng']
      sw_latitude  = json['results'][0]['geometry']['viewport']['southwest']['lat']
      sw_longitude = json['results'][0]['geometry']['viewport']['southwest']['lng']
      self.ne_latitude  = ne_latitude  unless ne_latitude.nil?
      self.ne_longitude = ne_longitude unless ne_longitude.nil?
      self.sw_latitude  = sw_latitude  unless sw_latitude.nil?
      self.sw_longitude = sw_longitude unless sw_longitude.nil?
    end

  end

  # Helper for #set_location_coordinates
  def call_google_api_for_location(address)
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{
                                          address}&key=#{ENV['GOOGLE_API_KEY']}"
    response = HTTParty.get url
    response.body
  end

  # Creates a +slug+ for generating readable url.  Slug is generated from
  # the clinic's name.  Slugs are all lower case and replace whitespace with '-'
  # Duplicate names will add '-n' to the end of the name
  # with n being the number of current duplicates
  # Ex: Three created clinics named 'My Clinic' will return
  # my-clinic, my-clinic-1, my-clinic-2, respectively
  def generate_slug
    if self.slug.blank? || self.slug.nil?
      unless self.name.blank?
        if Clinic.where(slug: name.parameterize).count != 0
          n = 1
          while Clinic.where(slug: "#{name.parameterize}-#{n}").count != 0
            n+= 1
          end
          self.slug = "#{name.parameterize}-#{n}"
        else
          self.slug = name.parameterize
        end
      else
        self.slug = 'no-name-entered'.parameterize
      end
    end
  end

  # +slug+ used in URL opposed to +id+
  def to_param
    slug
  end
end


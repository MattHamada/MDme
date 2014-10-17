class Clinic < ActiveRecord::Base
  has_and_belongs_to_many :patients
  #has_many :doctors
  has_many :appointments
  has_many :admins
  has_many :departments
  has_many :doctors

  validates  :name, presence: true, length: { maximum: 30 }
  validates  :slug, presence: true, uniqueness: true;

  before_validation :generate_slug
  before_create :get_location_coordinates


  scope :ordered_name, -> { order(name: :asc) }

  def get_location_coordinates
    api_key = "AIzaSyCDq1TX2uqhSDpRrtcebHzuNogcPPhKT0k"
    address = "#{self.address1}+" +
                        "#{self.address2 unless self.address2.nil?}+" +
                        "#{self.address3 unless self.address3.nil?}+" +
                        ", #{self.city}+" +
                        ", #{self.state unless self.state.nil?}+" +
                        "#{self.country}"
    address.gsub!(' ', '+')
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{api_key}"
    response = HTTParty.get url
    json = JSON.parse(response.body)
    latitude = json['results'][0]['geometry']['location']['lat']
    longitude = json['results'][0]['geometry']['location']['lng']
    self.latitude = latitude unless latitude.nil?
    self.longitude = longitude unless longitude.nil?
  end

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

  def to_param
    slug
  end
end

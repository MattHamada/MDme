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


  scope :ordered_name, -> { order(name: :asc) }

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

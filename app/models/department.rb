# Author: Matt Hamada
# Copyright MDme 2014
#
# Department model
# Used to group doctors based on specialty
#

class Department < ActiveRecord::Base
  has_many :doctors
  has_many :clinics

  validates :name, presence: true, uniqueness: {case_sensitive: false}, length: { maximum: 50 }
  validate :slug_unique_in_clinic

  before_validation :generate_slug

  def generate_slug
    unless self.name.blank?
      if Department.in_clinic(self).where(slug: name.parameterize).count != 0
        n = 1
        while Department.where(slug: "#{name.parameterize}-#{n}").count != 0
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

  def slug_unique_in_clinic
    errors.add(:slug, "Slug: #{slug} already in use") unless
        slug_unique_in_clinic?
  end

  def slug_unique_in_clinic?
    Department.in_clinic(self).where(slug: slug).count == 0
  end

  def self.in_clinic(model)
    if model.is_a?(Department)
      Department.where(clinic_id: model.clinic_id).where.not(id: model.id)
    else
      Department.where(clinic_id: model.clinic_id)
    end
  end

  def to_param
    slug
  end


  def num_doctors
    doctors.count
  end
end

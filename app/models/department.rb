#MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# Copyright:: Copyright (c) 2014 MDme

# Department model
# Used to group doctors based on specialty
class Department < ActiveRecord::Base
  has_many :doctors
  has_many :clinics

  validates :name, presence: true, length: { maximum: 50 }
  validate :name_unique_in_clinic
  validate :slug_unique_in_clinic

  before_validation :generate_slug

  # Creates a +slug+ for generating readable url.  Slug is generated from
  # the department's name.  Slugs are all lower case and replace
  # whitespace with '-'. Duplicate names will add '-n' to the end of the name
  # with n being the number of current duplicates
  # Ex: Three created departments named 'My Clinic' will return
  # my-department, my-clinic-1, my-clinic-2, respectively
  def generate_slug
    if self.slug.blank? || self.slug.nil?
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
  end

  # Finds all other departments in the same clinic as +model+
  # * +model+ - model passed to get get departments in same clinic.  Model
  # can be clinic or have a +clinic_id+
  def self.in_clinic(model)
    if model.is_a?(Department)
      Department.where(clinic_id: model.clinic_id).where.not(id: model.id)
    elsif model.is_a?(Patient)
      clinic_ids = []
      model.clinics.each { |c| clinic_ids << c.id }
      self.where(clinic_id: clinic_ids)
    else
      Department.where(clinic_id: model.clinic_id)
    end
  end

  # Adds error to instance is duplicate slug in same clinic
  def slug_unique_in_clinic
    errors.add(:slug, "Slug: #{slug} already in use") unless
        slug_unique_in_clinic?
  end

  # Checks if instance's slug is already in use in clinic
  def slug_unique_in_clinic?
    Department.in_clinic(self).where(slug: slug).count == 0
  end

  # Adds error to instance if it has the same name
  # as another department in the same clinic
  def name_unique_in_clinic
    errors.add(:name, "Name: #{name} already in use") unless
        name_unique_in_clinic?
  end

  # Chekcs if another department in the same clinic has the same name
  def name_unique_in_clinic?
    Department.in_clinic(self).where(name: name).count == 0
  end

  # Use +slug+ instead of +id+ in urls
  def to_param
    slug
  end

  # Return the number of doctors in the department
  def num_doctors
    doctors.count
  end
end

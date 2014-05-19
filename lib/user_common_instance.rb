module UserCommonInstance
  extend ActiveSupport::Concern, ActiveModel::Callbacks

  included do
    belongs_to :clinic

    validates :password, password_complexity: true,
              unless: :bypass_password_validation
    validates :email, presence: true, uniqueness: {case_sensitive: false},
             email_format: true, length: { maximum: 50 }
    validate :slug_unique_in_clinic

    before_save { self.email = email.downcase }
    before_validation :generate_slug
    before_create :create_remember_token
    after_create :send_confirmation_email
  end

    attr_accessor :bypass_password_validation

  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_slug
    if self.slug.blank? || self.slug.nil?
      unless full_name.blank?
        if self.class == Patient
          final_n = 0
          self.clinics.each do |clinic|
            if clinic.patients.where(slug: full_name.parameterize).count != 0
              n = final_n + 1
              while clinic.patients.where(slug:"#{full_name.parameterize}-#{n}").count != 0
                n += 1
              end
              final_n = n
            end
          end
          if final_n == 0
            self.slug = full_name.parameterize
          else
            self.slug = "#{full_name.parameterize}-#{final_n}"
          end
        else
          if self.class.in_clinic(self).where(slug: full_name.parameterize).count != 0
            n = 1
            while self.class.where(slug: "#{full_name.parameterize}-#{n}").count != 0
              n+= 1
            end
            self.slug = "#{full_name.parameterize}-#{n}"
          else
            self.slug = full_name.parameterize
          end
        end
      else
        slug = 'no-name-entered'.parameterize
      end
    end

  end


  def slug_unique_in_clinic
    errors.add(:slug, "Slug: #{slug} already in use") unless
        slug_unique_in_clinic?
  end

  def slug_unique_in_clinic?
    if self.is_a? Patient
      self.clinics.each do |clinic|
        patients = clinic.patients.where(slug: self.slug)
        #if there is a patient with same slug it is not self
        if patients.count != 0 && patients.first != self
          return false
        end
      end
      return true
    else
      self.class.in_clinic(self).where(slug: slug).count == 0
    end
  end

  def to_param
    slug
  end

  def send_password_reset_email(temppass)
    Thread.new do
      PasswordResetMailer.reset_email(self, temppass).deliver
    end
  end

  private



    def send_confirmation_email
      Thread.new do
        SignupMailer.signup_confirmation(self, password).deliver
      end
    end

    def create_remember_token
      self.remember_token = encrypt(new_remember_token)
    end

end
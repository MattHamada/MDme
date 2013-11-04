class Patient < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  validates :last_name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  validates :password, length: { minimum: 6 }

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_one  :doctor
  has_many :appointments

  has_secure_password


  def Patient.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Patient.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = Patient.encrypt(Patient.new_remember_token)
    end

end
